;;;; ***********************************************************************
;;;;
;;;; Name:          class-cons.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the cons class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'cons)) &rest initargs
                 &key (car nil)(cdr nil) &allow-other-keys)
  (cons car cdr))

(defmethod make ((type (eql (cl:find-class 'cl:cons))) &rest initargs
                 &key (car nil)(cdr nil) &allow-other-keys)
  (cons car cdr))

;;; function cons imported from cl

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 cons) (thing2 cons) &rest more-things)
  (cl:apply #'cl:equal thing1 thing2 more-things))

(defmethod identical? ((thing1 cons) (thing2 cons) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: pairs
;;; ---------------------------------------------------------------------

(defmethod left ((pair cl:cons))
  (cl:car pair))

(defmethod pair (left right)
  (cl:cons left right))

(defmethod pair? (thing) nil)
(defmethod pair? ((thing cl:cons)) t)

(defmethod right ((pair cl:cons))
  (cl:cdr pair))

(defmethod set-left! ((pair cl:cons) new-value)
  (cl:setf (cl:car pair) new-value))

(defmethod set-right! ((pair cl:cons) new-value)
  (cl:setf (cl:cdr pair) new-value))

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod cons? (thing) nil)
(defmethod cons? ((thing cl:cons)) t)
