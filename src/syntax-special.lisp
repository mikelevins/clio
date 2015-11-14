;;;; ***********************************************************************
;;;;
;;;; Name:          syntax-special.lisp
;;;; Project:       the clio language
;;;; Purpose:       clio special forms
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defmacro $ (fn &rest args)
  `(funcall ,fn ,@args))

(defmacro ^ (bindings &body body)
  `(lambda ,bindings ,@body))

(defmacro begin (block-name &rest expressions)
  `(block ,block-name ,@expressions))

(defmacro define (name val)
  `(defparameter ,name ,val))

(defmacro set! (place val)
  `(setf ,place ,val))

