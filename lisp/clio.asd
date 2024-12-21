;;;; ***********************************************************************
;;;;
;;;; Name:          clio.asd
;;;; Project:       clio: an Electron presentation server for Lisp
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
  :description "An Electron UI for Lisp programs"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :version (:read-file-form "version.lisp")
  :depends-on (
               :command-line-arguments ; [MIT] https://github.com/fare/command-line-arguments
               :find-port ; [MIT] https://github.com/eudoxia0/find-port
               )
  :build-operation "program-op"
  :build-pathname "clio"
  :entry-point "cl-user::main"
  :components ((:file "package")
               (:file "clio")
               (:file "main")))



#+test (asdf:load-system :clio)
