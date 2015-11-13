;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-conversion.lisp
;;;; Project:       the clio language
;;;; Purpose:       the type-conversion protocol 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric as (type object &key &allow-other-keys))
