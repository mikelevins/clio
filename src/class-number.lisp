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
