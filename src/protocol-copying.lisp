;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-copying.lisp
;;;; Project:       the clio language
;;;; Purpose:       making copies of objects
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric copy (object &key &allow-other-keys))


