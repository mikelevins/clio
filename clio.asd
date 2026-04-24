;;;; ***********************************************************************
;;;;
;;;; Name:          clio.asd
;;;; Project:       clio: an HTTP UI server in a Lisp library
;;;; Purpose:       system definition
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

;;; ---------------------------------------------------------------------
;;; clio system
;;; ---------------------------------------------------------------------

(asdf:defsystem #:clio
    :serial t
    :description "A Lisp HTTP UI server"
    :author "mikel evins <mevins@me.com>"
    :license "MIT"
    :version (:read-file-form "version.lisp")
    :depends-on (
                 :cl-json ; [MIT] https://github.com/hankhero/cl-json
                 :spinneret ; [MIT] https://github.com/ruricolist/spinneret
                 :hunchentoot ; [BSD] https://github.com/edicl/hunchentoot
                 :hunchensocket ; [BSD] https://github.com/joaotavora/hunchensocket
                 :net.bardcode.ksuid ; [Apache 2.0] local
                 :parenscript ; [BSD] https://github.com/vsedach/Parenscript
                 :find-port ; [MIT] https://github.com/eudoxia0/find-port
                 )
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "parameters")
                                       (:file "util")
                                       (:file "registry")
                                       (:file "server")
                                       (:file "browser-api")
                                       (:file "ui")))))




#+repl (asdf:load-system :clio)
#+repl (clio::start-server)
#+repl (clio::start-browser)
#+repl (clio::ping-browser)
#+repl (clio::stop-server)


;;; ---------------------------------------------------------------------
;;; tests
;;; ---------------------------------------------------------------------

#+repl (clio::initialize-handlers)

#+repl (loop for k being the hash-keys of clio::*message-handlers* collect k)
#+repl clio::*handler-initializers*
#+repl (hash-table-count clio::*message-handlers*)

#+repl (load (asdf:system-relative-pathname :clio "src/server.lisp"))
#+repl (load (asdf:system-relative-pathname :clio "src/browser-api.lisp"))

#+repl (clio::send-server-message (clio::encode-create-button "Inert"))
#+repl (clio::send-server-message (clio::encode-create-button "JS" :onclick "function(){alert('hi from JS');}"))
#+repl (clio::send-server-message (clio::encode-create-button "PS" :onclick '(lambda () (alert "hi from Parenscript"))))
#+repl (clio::send-server-message
        (clio::encode-create-button "Lisp"
                                    :onclick (lambda (elt payload)
                                               (declare (ignore payload))
                                               (format t "~&Lisp handler fired for ~A~%" elt))))
#+repl (hash-table-count clio::*element-registry*)
