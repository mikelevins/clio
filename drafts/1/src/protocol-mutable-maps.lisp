;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-mutable-maps.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on mutable maps
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric delete! (map key))
(defgeneric put! (map key value))


