;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-types.lisp
;;;; Project:       the clio language
;;;; Purpose:       functions for working with types and classes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric class (thing))

(defmethod class ((thing symbol))
  (find-class thing))
