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

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))

(asdf:defsystem #:clio
  :serial t
  :description "An Electron UI for Lisp programs"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :version (:read-file-form "version.lisp")
  :depends-on (
               :cl-who ; [BSD] https://edicl.github.io/cl-who/
               :hunchentoot ; [BSD] https://github.com/edicl/hunchentoot
               :command-line-arguments ; [MIT] https://github.com/fare/command-line-arguments
               :find-port ; [MIT] https://github.com/eudoxia0/find-port
               :trivial-ws ; [MIT] https://github.com/ceramic/trivial-ws
               )
  :build-operation "program-op"
  :build-pathname #+win32 "clio" #-win32 "clio.exe"
  :entry-point "cl-user::main"
  :components ((:file "package")
               (:file "parameters")
               (:file "util")
               (:file "ui")
               (:file "main")))



#+test (asdf:load-system :clio)
