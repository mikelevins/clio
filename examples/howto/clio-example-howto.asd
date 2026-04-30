;;;; ***********************************************************************
;;;;
;;;; Name:          clio-example-howto.asd
;;;; Project:       clio-example-howto
;;;; Purpose:       system definition for the HOWTO Clio example
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

;;; ---------------------------------------------------------------------
;;; clio-example-howto system
;;; ---------------------------------------------------------------------
;;; The :build-* and :entry-point keys make this system a candidate for
;;; ASDF:MAKE, which produces a standalone executable named "howto" by
;;; calling SAVE-LISP-AND-DIE through ASDF's program-op. CL-USER::MAIN
;;; is defined in howto.lisp; it is the dumped image's startup
;;; function. The HOWTO walks through the deployment workflow that
;;; relies on these keys.

(asdf:defsystem #:clio-example-howto
  :description "Clio synthesis example: Lisp-minted button + custom message type + HTMX fragment"
  :author "mikel evins <mevins@me.com>"
  :license "MIT"
  :depends-on (:clio)
  :serial t
  :build-operation "program-op"
  :build-pathname "howto"
  :entry-point "cl-user::main"
  :components ((:file "package")
               (:file "howto")))


#+repl (asdf:load-system :clio-example-howto)
#+repl (howto:start)
#+repl (howto:install-button)
#+repl (howto:announce "test announcement")
