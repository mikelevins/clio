;;;; package.lisp

(defpackage #:net.evins.clio
  (:nicknames :clio)
  (:use #:cl #:spinneret #:parenscript)
  (:export
   ;; deployment mode
   #:*deployment-mode*
   #:deployed-p
   #:with-deployment-mode
   ;; asset paths
   #:executable-relative-pathname
   #:asset-directory
   ;; static-folder dispatch
   #:serve-static-folder
   ;; diagnostics
   #:diagnose-asset-resolution))
