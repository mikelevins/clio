;;;; ***********************************************************************
;;;;
;;;; Name:          clio-example-hello.asd
;;;; Project:       clio-example-hello
;;;; Purpose:       system definition for the hello Clio example
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

(asdf:defsystem #:clio-example-hello
  :description "Clio hello-world example: input, button, checkbox, round-trip to Lisp"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :depends-on (:clio)
  :serial t
  :components ((:file "package")
               (:file "hello")))


#+repl (asdf:load-system :clio-example-hello)
#+repl (clio-example-hello:start)
