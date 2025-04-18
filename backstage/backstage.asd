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
                 :cl-who ; [BSD] https://edicl.github.io/cl-who/
                 :hunchentoot ; [BSD] https://github.com/edicl/hunchentoot
                 :sse-server ; [MIT] https://github.com/dtenny/cl-sse
                 :find-port ; [MIT] https://github.com/eudoxia0/find-port
                 :trivial-ws ; [MIT] https://github.com/ceramic/trivial-ws
                 )
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "parameters")
                                       (:file "util")
                                       (:file "server")
                                       (:file "ui")))))




#+test (asdf:load-system :backstage)
#+test (backstage::start-server backstage::*backstage-http-server-port*)
#+test (backstage::stop-server)
