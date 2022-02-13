;;;; ***********************************************************************
;;;;
;;;; Name:          clio.asd
;;;; Project:       the clio development environment
;;;; Purpose:       system definition
;;;; Author:        mikel evins
;;;; Copyright:     2021-2022 by mikel evins
;;;;
;;;; ***********************************************************************

;;; ---------------------------------------------------------------------
;;; clio
;;; ---------------------------------------------------------------------

;;; make sure we load hunchentoot at the start with
;;; :hunchentoot-no-ssl on *features*, so that we don't run into
;;; problems loading cl+ssl
(eval-when (:compile-toplevel :load-toplevel :execute)
  (pushnew :HUNCHENTOOT-NO-SSL *features*))

(asdf:defsystem #:clio
  :description "Clio: a Lisp development environment with HTML5 UI support"
  :author "mikel evins <mikel@evns.net>"
  :license  "MIT"
  :version "0.5.1"
  :depends-on ()
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "clio")))))

#+nil (asdf:load-system :clio)


