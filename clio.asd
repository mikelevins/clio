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
    :depends-on (:fset :series :local-time :puri)
    :components ((:module "src"
                          :serial t
                          :components ((:file "package")
                                       (:file "special")
                                       (:file "protocol-conversion")
                                       (:file "protocol-construction")
                                       (:file "protocol-pairs")
                                       (:file "protocol-sequences")
                                       (:file "protocol-math")
                                       (:file "protocol-comparison")
                                       (:file "protocol-maps")
                                       (:file "protocol-types")
                                       (:file "protocol-time")
                                       (:file "protocol-resources")
                                       (:file "protocol-system")
                                       (:file "version")))))

;;; (asdf:load-system :clio)
