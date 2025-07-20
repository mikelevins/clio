;;;; ***********************************************************************
;;;;
;;;; Name:          backstage.asd
;;;; Project:       backstage: an HTTP UI server in a Lisp library
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

(asdf:defsystem #:backstage
    :serial t
    :description "A Lisp HTTP UI server"
    :author "mikel evins <mevins@me.com>"
    :license "MIT"
    :version (:read-file-form "version.lisp")
    :depends-on (
                 :cl-json
                 :cl-who ; [BSD] https://edicl.github.io/cl-who/
                 :hunchentoot ; [BSD] https://github.com/edicl/hunchentoot
                 :parenscript
                 :find-port ; [MIT] https://github.com/eudoxia0/find-port
                 :trivial-ws ; [MIT] https://github.com/ceramic/trivial-ws
                 )
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "parameters")
                                       (:file "util")
                                       (:file "server")
                                       (:file "browser-api")
                                       (:file "ui")))))




#+repl (asdf:load-system :backstage)

