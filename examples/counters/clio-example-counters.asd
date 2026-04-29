;;;; ***********************************************************************
;;;;
;;;; Name:          clio-example-counters.asd
;;;; Project:       clio-example-counters
;;;; Purpose:       system definition for the counters Clio example
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

(asdf:defsystem #:clio-example-counters
  :description "Clio registry example: three buttons with Lisp-side click handlers"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :depends-on (:clio)
  :serial t
  :components ((:file "package")
               (:file "counters")))


#+repl (asdf:load-system :clio-example-counters)
#+repl (clio-example-counters:start)
#+repl (clio-example-counters:install-buttons)
