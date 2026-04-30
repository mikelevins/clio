;;;; ***********************************************************************
;;;;
;;;; Name:          deployment.lisp
;;;; Project:       clio: an HTTP UI server in a Lisp library
;;;; Purpose:       deployment-mode awareness and asset-path resolution
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)


;;; ---------------------------------------------------------------------
;;; deployment mode
;;; ---------------------------------------------------------------------
;;; Clio supports two modes of operation: development, where assets
;;; are resolved via ASDF, and deployed, where assets are resolved
;;; relative to the running executable. The mode cannot be reliably
;;; inferred from runtime state (a freshly-built executable run on
;;; the dev host looks identical from disk to a development image
;;; running from the same project directory), so the build script
;;; sets the mode explicitly before save-lisp-and-die.
;;;
;;; *DEPLOYMENT-MODE* is a defparameter rather than a defvar so that
;;; reads from any context return :development by default; consumers
;;; never have to guard for unbound-variable.

(defparameter *deployment-mode* :development
  "Either :DEVELOPMENT or :DEPLOYED. Set to :DEPLOYED by the build
script (or via WITH-DEPLOYMENT-MODE) before SAVE-LISP-AND-DIE so the
dumped image carries the deployed flag. The HOWTO walks through the
build pattern.")

(defun deployed-p ()
  "True if Clio is running in :DEPLOYED mode, false during development."
  (eq *deployment-mode* :deployed))

(defmacro with-deployment-mode ((mode) &body body)
  "Binds *DEPLOYMENT-MODE* to MODE for the dynamic extent of BODY,
restoring the prior value on exit. Useful at the REPL when building
a deployed image without leaving the dev session in :DEPLOYED mode:

    (clio:with-deployment-mode (:deployed)
      (asdf:make :howto))"
  `(let ((*deployment-mode* ,mode))
     ,@body))


;;; ---------------------------------------------------------------------
;;; asset paths
;;; ---------------------------------------------------------------------
;;; ASSET-DIRECTORY is the function consumer code calls to wire up
;;; Clio's bundled assets. It dispatches on deployment mode:
;;;
;;;   :development -- resolve via ASDF:SYSTEM-RELATIVE-PATHNAME
;;;   :deployed    -- resolve relative to (UIOP:ARGV0)
;;;
;;; In deployed mode the convention is that the deploy bundle has
;;; Clio's public/ contents copied to public/clio/ next to the
;;; executable. The HOWTO documents this layout and the build script
;;; that produces it.

(defun executable-relative-pathname (relative-path)
  "Returns a pathname computed relative to the directory containing
the running executable, located via UIOP:ARGV0. Useful for resolving
asset directories in standalone deployments."
  (merge-pathnames relative-path
                   (make-pathname :defaults (uiop:argv0)
                                  :name nil :type nil)))

(defun asset-directory ()
  "Returns the pathname of Clio's bundled public/ directory. In
development, located via ASDF. In a deployed executable, located
relative to the executable assuming the deploy-bundle layout
documented in the HOWTO (Clio's assets at public/clio/ next to the
executable)."
  (if (deployed-p)
      (executable-relative-pathname "public/clio/")
      (asdf:system-relative-pathname :clio "public/")))


;;; ---------------------------------------------------------------------
;;; static-folder dispatch
;;; ---------------------------------------------------------------------
;;; Hunchentoot's built-in CREATE-FOLDER-DISPATCHER-AND-HANDLER
;;; matches by URI prefix and then claims the request: if the file
;;; doesn't exist on disk, the handler 404s rather than letting
;;; *DISPATCH-TABLE* keep searching. That makes a folder dispatcher
;;; mounted at \"/\" shadow every easy-handler on the server,
;;; including Clio's built-in /favicon.ico shim.
;;;
;;; SERVE-STATIC-FOLDER inverts that: it returns NIL (falls through)
;;; when the requested path isn't a regular file under
;;; FOLDER-PATHNAME, so easy-handlers and later dispatchers get their
;;; turn. This is what makes the recommended drop-in layout work --
;;; the consumer copies Clio's public/ contents into their own
;;; public/clio/ and mounts a single dispatcher at \"/\" without
;;; shadowing anything.

(defun serve-static-folder (uri-prefix folder-pathname)
  "Registers a fall-through static-folder dispatcher serving
FOLDER-PATHNAME at URI-PREFIX. URI-PREFIX must end with a slash;
\"/\" maps the folder to the URL root. Unlike Hunchentoot's built-in
folder dispatcher, this one returns NIL when no regular file exists
at the requested path, so easy-handlers and other dispatchers can
still match. Path components containing \"..\" are rejected to
prevent traversal outside FOLDER-PATHNAME. With the recommended
drop-in layout (Clio's public/ contents copied into the consumer's
public/clio/), one call suffices:

    (clio:serve-static-folder \"/\"
      (if (clio:deployed-p)
          (clio:executable-relative-pathname \"public/\")
          (asdf:system-relative-pathname :myapp \"public/\")))"
  (push (lambda (request)
          (let* ((script-name (hunchentoot:url-decode
                               (hunchentoot:script-name request)))
                 (prefix-len (length uri-prefix)))
            (when (and (>= (length script-name) prefix-len)
                       (string= uri-prefix script-name :end2 prefix-len)
                       (not (search ".." script-name)))
              (let* ((relative (subseq script-name prefix-len))
                     (file (merge-pathnames relative folder-pathname)))
                (when (uiop:file-exists-p file)
                  (lambda () (hunchentoot:handle-static-file file)))))))
        hunchentoot:*dispatch-table*)
  (values))


;;; ---------------------------------------------------------------------
;;; diagnostics
;;; ---------------------------------------------------------------------
;;; ASDF's source registry can be misconfigured such that more than
;;; one path looks plausible for the :clio system, in which case
;;; ASDF:SYSTEM-SOURCE-DIRECTORY returns one of them
;;; nondeterministically. The startup message in START-SERVER names
;;; the resolved path so a developer notices the mismatch
;;; immediately. DIAGNOSE-ASSET-RESOLUTION is a richer alternative
;;; the developer can call when the startup message is suspicious.

(defun diagnose-asset-resolution ()
  "Prints diagnostic information about how Clio is resolving asset
paths, including the current deployment mode and the directory
ASSET-DIRECTORY currently returns. In development mode, also reports
the ASDF source directory for :clio so misconfigurations of the ASDF
source registry are visible."
  (format t "~&Deployment mode: ~A~%" *deployment-mode*)
  (format t "Resolved asset directory: ~A~%" (asset-directory))
  (unless (deployed-p)
    (format t "ASDF source directory for :clio: ~A~%"
            (asdf:system-source-directory :clio)))
  (values))
