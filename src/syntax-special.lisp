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

(defmacro bind (bindings &body body)
  (let* ((len (cl:length bindings))
         (vars (subseq bindings 0 (1- len)))
         (valform (cl:first (cl:last bindings))))
    `(multiple-value-bind ,vars ,valform
       ,@body)))

(defmacro define (name val)
  `(defparameter ,name ,val))

(defmacro ensure (&key first then)
  `(unwind-protect ,first ,then))

(defmacro let (bindings &body body)
  `(cl:let* ,bindings ,@body))

(defmacro set! (place val)
  `(setf ,place ,val))

