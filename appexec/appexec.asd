;;;; ***********************************************************************
;;;;
;;;; Name:          app.asd
;;;; Project:       appexec: a skeletal commandline app in Lisp
;;;; Purpose:       system definition
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

;;; ---------------------------------------------------------------------
;;; appexec system
;;; ---------------------------------------------------------------------

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))

(asdf:defsystem #:appexec
  :serial t
  :description "A command-line executable skeleton for Lisp"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :version (:read-file-form "version.lisp")
  :depends-on (:command-line-arguments ; [MIT] https://github.com/fare/command-line-arguments
               )
  :build-operation "program-op"
  :build-pathname #+win32 "app" #-win32 "app.exe"
  :entry-point "cl-user::main"
  :components ((:file "package")
               (:file "parameters")
               (:file "util")
               (:file "main")))



#+test (asdf:load-system :appexec)
