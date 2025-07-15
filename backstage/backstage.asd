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
                 :flexi-streams ; [BSD] https://github.com/edicl/flexi-streams
                 :cl-who ; [BSD] https://edicl.github.io/cl-who/
                 :hunchentoot ; [BSD] https://github.com/edicl/hunchentoot
                 :parenscript
                 :sse-server
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




#+repl (asdf:load-system :backstage)
#+repl (backstage::start-server backstage::*backstage-http-server-port*)
#+repl (backstage::start-browser)
#+repl (backstage::stop-server)


;;; remote-js
;;; ---------------------------------------------------------------------

#+repl (defparameter ctx (remote-js:make-context))
#+repl (remote-js:start ctx)
#+repl (with-open-file (stream (merge-pathnames #p"test.html" (user-homedir-pathname))
                               :direction :output
                               :if-exists :supersede
                               :if-does-not-exist :create)
         (write-string (remote-js:html ctx) stream))
#+test (backstage::start-browser)
#+test (remote-js:eval ctx "alert('hello!')")

