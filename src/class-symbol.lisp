;;;; ***********************************************************************
;;;;
;;;; Name:          class-symbol.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the symbol class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)


;;; NOTE:
;;; we want a generic function named string, so we
;;; shadow that symbol from CL and cause it to refer to
;;; the CL class of the same name.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::symbol)
           (cl:find-class 'cl::symbol)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defun symbol (name &optional package)
  (if package
      (cl:make-symbol name)
      (cl:intern name package)))


;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 symbol) (thing2 symbol) &rest more-things)
  (if (cl:string= (cl:symbol-name thing1)
                  (cl:symbol-name thing2))
      (if more-things
          (cl:apply #'= thing2 more-things)
          t)
      nil))

(defmethod identical? ((thing1 symbol) (thing2 symbol) &rest more-things)
  (if (cl:eq thing1 thing2)
      (if more-things
          (cl:apply #'identical? thing2 more-things)
          t)
      nil))

;;; ---------------------------------------------------------------------
;;; protocol: functions
;;; ---------------------------------------------------------------------

(defmethod fbound? ((symbol symbol))
  (cl:fboundp symbol))

(defmethod funbind! ((symbol symbol))
  (cl:fmakunbound symbol))

;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: symbols
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod symbol? (thing) nil)
(defmethod symbol? ((thing cl:symbol)) t)
