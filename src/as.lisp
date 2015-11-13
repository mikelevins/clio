;;;; ***********************************************************************
;;;;
;;;; Name:          as.lisp
;;;; Project:       the clio language
;;;; Purpose:       generic type-conversion 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defgeneric as (type object &key &allow-other-keys))
