;;;; ***********************************************************************
;;;;
;;;; Name:          special.lisp
;;;; Project:       the clio language
;;;; Purpose:       clio special forms
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)


;;; macro $
;;; 
;;; ($ fn  expr1..exprk) => Anything
;;; ---------------------------------------------------------------------
;;; A more compact synonym for FUNCALL. This macro is not intended as
;;; a replacement for FUNCALL, but as a convenience for cases in
;;; which the clarity of functional code benefits from compactness.

(defmacro $ (f &rest args)
  `(cl:funcall ,f ,@args))

;;; macro ^
;;; 
;;; (^ (arg1..argk)  expr1..exprk) => a function
;;; ---------------------------------------------------------------------
;;; A more compact synonym for LAMBDA. This macro is not intended as
;;; a replacement for LAMBDA, but as a convenience for cases in
;;; which the clarity of functional code benefits from compactness.

(defmacro ^ (args &body body)
  `(lambda ,args ,@body))


(defmacro begin (&rest exprs)
  `(cl:progn ,@exprs))

(defmacro bind (bindings &body body)
  (cl:let* ((bindings-count (cl:length bindings))
            (vars (cl:subseq bindings 0 (cl:1- bindings-count)))
            (vals-form (cl:first (cl:last bindings))))
    `(cl:multiple-value-bind (,@vars) ,vals-form ,@body)))

(defmacro define (varname val)
  `(cl:defparameter ,varname ,val))

(defmacro let (bindings &body body)
  `(cl:let* ,bindings ,@body))

(defmacro set! (place val)
  `(cl:setf ,place ,val))

