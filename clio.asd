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
;;; clio
;;; ---------------------------------------------------------------------

(asdf:defsystem #:clio
    :serial t
    :description "A language about data"
    :author "mikel evins <mevins@me.com>"
    :license "Apache 2.0"
    :depends-on (:sqlite :fare-csv)
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "version")
                                       (:file "utilities")
                                       (:file "storage")))))

;;; (asdf:load-system :clio)
