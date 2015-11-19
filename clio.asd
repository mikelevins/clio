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
    :description "Common Lisp's simpler newphew"
    :author "mikel evins <mevins@me.com>"
    :license "Apache 2.0"
    :depends-on (:fset :series :local-time :puri :cl-singleton-mixin)
    :components ((:module "src"
                          :serial t
                          :components ((:file "package-clio-internal")
                                       (:file "package-clio")
                                       (:file "protocol-conditions")
                                       (:file "protocol-construction")
                                       (:file "protocol-equal")
                                       (:file "protocol-copying")
                                       (:file "protocol-functions")
                                       (:file "protocol-ordered")
                                       (:file "protocol-pairs")
                                       (:file "protocol-maps")
                                       (:file "protocol-bytes")
                                       (:file "protocol-characters")
                                       (:file "protocol-math")
                                       (:file "protocol-symbols")
                                       (:file "protocol-sequences")
                                       (:file "protocol-serialization")
                                       (:file "protocol-uris")
                                       (:file "protocol-streams")
                                       (:file "class-stream")
                                       (:file "protocol-taps")
                                       (:file "protocol-system")
                                       (:file "protocol-time")
                                       (:file "protocol-types")
                                       (:file "class-character")
                                       (:file "class-condition")
                                       (:file "class-cons")
                                       (:file "class-list")
                                       (:file "class-eof")
                                       (:file "class-hash-table")
                                       (:file "class-map")
                                       (:file "class-null")
                                       (:file "class-number")
                                       (:file "class-package")
                                       (:file "class-seq")
                                       (:file "class-series")
                                       (:file "class-string")
                                       (:file "class-symbol")
                                       (:file "class-timestamp")
                                       (:file "class-uri")
                                       (:file "class-vector")
                                       (:file "protocol-conversion") ; need class definitions before conversions
                                       (:file "syntax-list")
                                       (:file "syntax-map")
                                       (:file "syntax-special")
                                       (:file "version")))))

;;; (asdf:load-system :clio)
