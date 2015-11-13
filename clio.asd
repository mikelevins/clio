;;;; ***********************************************************************
;;;;
;;;; Name:          clio.asd
;;;; Project:       the clio language
;;;; Purpose:       system definition
;;;; Author:        mikel evins
;;;; Copyright:     2014 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(require :asdf)

;;; ---------------------------------------------------------------------
;;; clio system
;;; ---------------------------------------------------------------------

(asdf:defsystem #:clio
    :serial t
    :description "Describe clio here"
    :author "Your Name <your.name@example.com>"
    :license "Specify license here"
    :depends-on (:fset :series)
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "special")
                                       (:file "make")
                                       (:file "as")
                                       (:file "pair")
                                       (:file "list-syntax")))))

;;; (asdf:load-system :clio)

