;;;; ***********************************************************************
;;;;
;;;; Name:          server.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       Clio application server
;;;; Author:        mikel evins
;;;; Copyright:     2024-2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio)

;;; ---------------------------------------------------------------------
;;; acceptor
;;; ---------------------------------------------------------------------
;;; clio-acceptor inherits from both hunchensocket:websocket-acceptor
;;; (so that WebSocket upgrade requests are intercepted and dispatched
;;; through hunchensocket) and hunchentoot:easy-acceptor (so that
;;; define-easy-handler and document-root static file serving continue
;;; to work). Ordinary requests fall through to easy-acceptor's
;;; dispatch; upgrade requests are handled by websocket-acceptor.

(defclass clio-acceptor (hunchensocket:websocket-acceptor
                         hunchentoot:easy-acceptor)
  ())

;;; start-listening specialized on clio-acceptor, replacing the former
;;; cross-package monkey-patch on hunchentoot:acceptor. The socket is
;;; opened with SO_REUSEADDR so that restarts during development don't
;;; fail with "address in use".

(defmethod hunchentoot:start-listening ((acceptor clio-acceptor))
  (when (hunchentoot::acceptor-listen-socket acceptor)
    (hunchentoot::hunchentoot-error "acceptor ~A is already listening" acceptor))
  (setf (hunchentoot::acceptor-listen-socket acceptor)
        (usocket:socket-listen (or (hunchentoot:acceptor-address acceptor)
                                   usocket:*wildcard-host*)
                               (hunchentoot:acceptor-port acceptor)
                               :reuseaddress t
                               :reuse-address t
                               :backlog (hunchentoot::acceptor-listen-backlog acceptor)
                               :element-type '(unsigned-byte 8)))
  (values))

;;; ---------------------------------------------------------------------
;;; websocket resource
;;; ---------------------------------------------------------------------
;;; A single clio-ws-resource instance is bound to the /ws path and
;;; serves every connected client.

(defclass clio-ws-resource (hunchensocket:websocket-resource)
  ())

(defun find-ws-resource (request)
  (when (equal (hunchentoot:script-name request) "/ws")
    *clio-ws-resource*))

(pushnew 'find-ws-resource hunchensocket:*websocket-dispatch-table*)

;;; ---------------------------------------------------------------------
;;; message dispatch
;;; ---------------------------------------------------------------------
;;; Browser-to-Lisp messages are JSON objects with a :type field.
;;; Handlers are registered by type-string and are called with the
;;; resource, the client, and the parsed message alist.

(defparameter *message-handlers* (make-hash-table :test 'equal))

(defun register-message-handler (type handler)
  (setf (gethash type *message-handlers*) handler))

(defun unregister-message-handler (type)
  (remhash type *message-handlers*))

;;; ---------------------------------------------------------------------
;;; handler initializers
;;; ---------------------------------------------------------------------
;;; *MESSAGE-HANDLERS* above is a defparameter, matching the discipline
;;; elsewhere in Clio: reload a file, reset the state that file owns.
;;; But the handlers themselves are contributed by several files (this
;;; one contributes ping/pong; browser-api.lisp contributes
;;; element-event), and reloading server.lisp alone would silently
;;; lose the handlers contributed by other files.
;;;
;;; The fix is an initializer registry. Each file that contributes
;;; handlers defines a zero-argument function that (re-)registers its
;;; handlers, and calls REGISTER-HANDLER-INITIALIZER at top level with
;;; a symbol naming that function. *HANDLER-INITIALIZERS* lives in
;;; parameters.lisp and thus persists across reloads of this file.
;;; INITIALIZE-HANDLERS clears *MESSAGE-HANDLERS* and runs every
;;; registered initializer. It is called from:
;;;
;;;   - the trailing form at the bottom of this file, so reloading
;;;     server.lisp alone restores every contributor's handlers;
;;;   - START-SERVER, so starting a server always begins with a
;;;     known-good handler table.
;;;
;;; Initializer names and the handlers themselves are stored as
;;; symbols rather than function objects: FUNCALL on a symbol looks up
;;; the current symbol-function, so redefining a function via DEFUN is
;;; picked up automatically on the next dispatch; and PUSHNEW on a
;;; symbol dedupes correctly across reloads (two #'FOO values after
;;; redefinition are not EQ, but 'FOO is always EQ to itself).

(defun register-handler-initializer (name)
  "Adds NAME (a symbol naming a zero-argument function) to
*HANDLER-INITIALIZERS* if not already present, and immediately
funcalls it to install that file's handlers. Intended as a top-level
call in each file that contributes built-in message handlers."
  (pushnew name *handler-initializers*)
  (funcall name))

(defun initialize-handlers ()
  "Clears *MESSAGE-HANDLERS* and re-runs every initializer named in
*HANDLER-INITIALIZERS*, in order of registration. Safe to call at any
time; called from START-SERVER and from the trailing form at the
bottom of this file."
  (clrhash *message-handlers*)
  (dolist (name (reverse *handler-initializers*))
    (funcall name)))

(defparameter *display-client-messages* nil)

(defun handle-client-message (resource client message)
  (when *display-client-messages*
    (format t "~&Received message from the browser client: ~%  ~S~%" message))
  (let* ((parsed (cl-json:decode-json-from-string message))
         (type (cdr (assoc :type parsed)))
         (handler (gethash type *message-handlers*)))
    (if handler
        (funcall handler resource client parsed)
        (format t "~&No handler for browser message type ~S: ~%  ~S~%" type message))))

(defmethod hunchensocket:text-message-received ((resource clio-ws-resource) client message)
  (handle-client-message resource client message))

(defmethod hunchensocket:client-connected ((resource clio-ws-resource) client)
  (declare (ignore resource client))
  (format t "~&Connected~%"))

(defmethod hunchensocket:client-disconnected ((resource clio-ws-resource) client)
  (declare (ignore resource client))
  (format t "~&Disconnected~%"))

;;; ---------------------------------------------------------------------
;;; sending messages to the browser
;;; ---------------------------------------------------------------------

(defun send-server-message (json)
  (let ((client (first (hunchensocket:clients *clio-ws-resource*))))
    (when client
      (hunchensocket:send-text-message client json))))

;;; ---------------------------------------------------------------------
;;; built-in ping / pong
;;; ---------------------------------------------------------------------
;;; Round-trip sanity check in both directions. When the browser sends
;;; a ping, Lisp replies with a pong. When the browser sends a pong (in
;;; reply to a Lisp-initiated ping), Lisp logs it.

(defun handle-ping (resource client parsed)
  (declare (ignore resource client parsed))
  (format t "~&Received ping from the browser~%")
  (send-server-message (encode-pong)))

(defun handle-pong (resource client parsed)
  (declare (ignore resource client parsed))
  (format t "~&Received pong from the browser~%"))

(defun initialize-server-message-handlers ()
  "Registers the built-in message handlers contributed by this file.
Called by REGISTER-HANDLER-INITIALIZER on load, and again by
INITIALIZE-HANDLERS whenever the handler table is rebuilt."
  (register-message-handler "ping" 'handle-ping)
  (register-message-handler "pong" 'handle-pong))

(register-handler-initializer 'initialize-server-message-handlers)

(defun ping-browser ()
  (send-server-message (encode-ping)))

#+repl (ping-browser)

;;; ---------------------------------------------------------------------
;;; server operations
;;; ---------------------------------------------------------------------

(defun start-server (&key (show-lisp-errors t))
  (setf hunchentoot:*show-lisp-errors-p* show-lisp-errors)
  (if (and *clio-server* (listening? *clio-server*))
      (warn "The Clio server is already running")
      (progn (initialize-handlers)
             (unless *clio-ws-resource*
               (setf *clio-ws-resource* (make-instance 'clio-ws-resource)))
             (setf *clio-server*
                   (make-instance 'clio-acceptor
                                  :port *clio-server-port*
                                  :document-root (http-document-root)))
             (hunchentoot:start *clio-server*)
             *clio-server*)))

#+repl (start-server)

(defun stop-server ()
  (when (listening? *clio-server*)
    (hunchentoot:stop *clio-server*)))

#+repl (stop-server)

(defmethod listening? ((server null)) nil)

(defmethod listening? ((server hunchentoot:acceptor))
  (and (hunchentoot::acceptor-listen-socket server) t))

#+repl (listening? *clio-server*)

(defun start-browser (&optional (url (format nil "http://localhost:~A/" *clio-server-port*)))
  #+(or win32 mswindows windows)
  (uiop:run-program (format nil "explorer ~S" url))
  #+(or macos darwin)
  (uiop:run-program (format nil "open ~S" url))
  #-(or win32 mswindows macos darwin windows)
  (uiop:run-program (format nil "xdg-open ~S" url)))

;;; ---------------------------------------------------------------------
;;; restore handler table on (re)load
;;; ---------------------------------------------------------------------
;;; Final form: rebuild *MESSAGE-HANDLERS* from every initializer name
;;; currently in *HANDLER-INITIALIZERS*. On a fresh full-system load
;;; this runs before browser-api.lisp has loaded, so only server's own
;;; initializer is in the list at this point; browser-api.lisp's
;;; top-level REGISTER-HANDLER-INITIALIZER call installs element-event
;;; a moment later. On a single-file reload of this file,
;;; *HANDLER-INITIALIZERS* still holds every contributor's name (it
;;; lives in parameters.lisp), so this call restores the complete
;;; handler table without requiring that other handler files also be
;;; reloaded.

(initialize-handlers)
