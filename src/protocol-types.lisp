;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-types.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on types and classes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric class (thing))
(defgeneric class? (thing))
(defgeneric instance? (object type))
(defgeneric subclass? (class1 class2))
(defgeneric subtype? (type1 type2))
(defgeneric type (thing))
(defgeneric type? (thing))
