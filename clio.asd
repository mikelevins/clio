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
  :description "Apis: swarms of threads and processes passing messages"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :version (:read-file-form "version.lisp")
  :depends-on (
               :find-port ; [MIT] https://github.com/eudoxia0/find-port
               )
  :components ((:file "package")
               (:file "clio")))

;;; (asdf:load-system :clio)
;;; (ql:quickload :clio)
