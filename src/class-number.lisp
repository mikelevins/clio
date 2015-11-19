;;;; ***********************************************************************
;;;;
;;;; Name:          class-number.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the number classes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; protocol: bytes
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: characters
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:= thing1 thing2 more-things))

(defmethod identical? ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: math
;;; ---------------------------------------------------------------------

(defmethod complex? (thing) nil)
(defmethod complex? ((thing cl:complex)) t)

(defmethod even? (thing)
  (error "Not an integer: ~S" thing))

(defmethod even? ((thing cl:integer))
  (cl:evenp thing))

(defmethod float? (thing) nil)
(defmethod float? ((thing cl:float)) t)

(defmethod integer? (thing) nil)
(defmethod integer? ((thing cl:integer)) t)

(defmethod minus? (thing)
  (error "Not a number: ~S" thing))

(defmethod minus? ((thing cl:number))
  (cl:minusp thing))

(defmethod number? (thing) nil)
(defmethod number? ((thing cl:number)) t)

(defmethod odd? (thing)
  (error "Not an integer: ~S" thing))

(defmethod odd? ((thing cl:integer))
  (cl:oddp thing))

(defmethod plus? (thing)
    (error "Not a number: ~S" thing))

(defmethod plus? ((thing cl:number))
  (cl:plusp thing))

(defmethod random-state? (thing) nil)
(defmethod random-state? ((thing cl:rational)) t)

(defmethod rational? (thing) nil)

(defmethod rational? ((thing cl:number))
  (cl:rationalp thing))

(defmethod real? (thing) nil)

(defmethod real? ((thing number))
  (cl:realp thing))

(defmethod zero? (thing) nil)

(defmethod zero? ((thing cl:number))
  (cl:zerop thing))

(defmacro dec! (place &optional (delta 1))
  `(cl:decf ,place ,delta))

(defmacro inc! (place &optional (delta 1))
  `(cl:incf ,place ,delta))

;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------

(defmethod < ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:< thing1 thing2 more-things))

(defmethod <= ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:<= thing1 thing2 more-things))

(defmethod > ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:> thing1 thing2 more-things))

(defmethod >= ((thing1 number) (thing2 number) &rest more-things)
  (cl:apply #'cl:>= thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod number? (thing) nil)
(defmethod number? ((thing cl:number)) t)
