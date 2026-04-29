;;;; ***********************************************************************
;;;;
;;;; Name:          clio-example-htmx.asd
;;;; Project:       clio-example-htmx
;;;; Purpose:       system definition for the HTMX Clio example
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

(asdf:defsystem #:clio-example-htmx
  :description "Clio HTMX example: request/response greeting and live-filter input"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :depends-on (:clio)
  :serial t
  :components ((:file "package")
               (:file "htmx")))


#+repl (asdf:load-system :clio-example-htmx)
#+repl (clio-example-htmx:start)
