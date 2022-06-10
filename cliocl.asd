;;;; ***********************************************************************
;;;;
;;;; Name:          cliocl.asd
;;;; Project:       the clio Common Lisp development environment
;;;; Purpose:       system definition
;;;; Author:        mikel evins
;;;; Copyright:     2021-2022 by mikel evins
;;;;
;;;; ***********************************************************************

;;; ---------------------------------------------------------------------
;;; cliocl
;;; ---------------------------------------------------------------------

;;; make sure we load hunchentoot at the start with
;;; :hunchentoot-no-ssl on *features*, so that we don't run into
;;; problems loading cl+ssl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew :HUNCHENTOOT-NO-SSL *features*))

(asdf:defsystem #:cliocl
  :description "Clio: a Lisp development environment with HTML5 UI support"
  :author "mikel evins <mikel@evns.net>"
  :license  "MIT"
  :version "0.6.1"
  :depends-on (:hunchentoot :trivial-ws :parenscript :st-json :cl-who :lass)
  :serial t
  :components ((:module "lisp"
                :serial t
                :components ((:file "package")
                             (:file "parameters")
                             (:file "http-server")
                             (:file "ui")
                             (:file "routes")))))

#+nil (asdf:load-system :cliocl)

#+nil (cliocl::start-server 8000)
#+nil (cliocl::stop-server)


#+nil (trivial-ws:send (first (trivial-ws:clients cliocl::*websocket-server*)) "{\"name\": \"Goodbye!\"}")
