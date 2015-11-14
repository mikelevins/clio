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
    :depends-on (:fset :series :local-time :puri :cl-singleton-mixin)
    :components ((:module "src"
                          :serial t
                          :components ((:file "package-clio-internal")
                                       (:file "package-clio")
                                       (:file "protocol-bytes")
                                       (:file "protocol-characters")
                                       (:file "protocol-comparison")
                                       (:file "protocol-conditions")
                                       (:file "protocol-construction")
                                       (:file "protocol-conversion")
                                       (:file "protocol-functions")
                                       (:file "protocol-maps")
                                       (:file "protocol-math")
                                       (:file "protocol-names")
                                       (:file "protocol-pairs")
                                       (:file "protocol-sequences")
                                       (:file "protocol-serialization")
                                       (:file "protocol-series")
                                       (:file "protocol-streams")
                                       (:file "protocol-system")
                                       (:file "protocol-time")
                                       (:file "protocol-types")
                                       (:file "class-character")
                                       (:file "class-condition")
                                       (:file "class-cons")
                                       (:file "class-eof")
                                       (:file "class-hash-table")
                                       (:file "class-map")
                                       (:file "class-null")
                                       (:file "class-number")
                                       (:file "class-package")
                                       (:file "class-seq")
                                       (:file "class-series")
                                       (:file "class-stream")
                                       (:file "class-string")
                                       (:file "class-symbol")
                                       (:file "class-timestamp")
                                       (:file "class-uri")
                                       (:file "class-vector")
                                       (:file "syntax-list")
                                       (:file "syntax-map")
                                       (:file "syntax-special")
                                       (:file "version")))))

;;; (asdf:load-system :clio)
