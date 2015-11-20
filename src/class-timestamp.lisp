;;;; ***********************************************************************
;;;;
;;;; Name:          class-timestamp.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the timestamp class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defun timestamp (nsec sec minute hour day month year &key timezone offset)
  (local-time:encode-timestamp nsec sec minute hour day month year
                               :timezone timezone :offset offset))


;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: copying
;;; ---------------------------------------------------------------------

(defmethod copy ((object timestamp) &key &allow-other-keys)
  (local-time::clone-timestamp object))

;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (cl:apply #'timestamp= thing1 thing2 more-things))

(defmethod identical? ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (if (cl:eq thing1 thing2)
      (if more-things
          (cl:apply #'identical? thing2 more-things)
          t)
      nil))

;;; ---------------------------------------------------------------------
;;; protocol: math
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------

(defmethod < ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (cl:apply #'timestamp< thing1 thing2 more-things))

(defmethod <= ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (cl:apply #'timestamp<= thing1 thing2 more-things))

(defmethod > ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (cl:apply #'timestamp> thing1 thing2 more-things))

(defmethod >= ((thing1 timestamp) (thing2 timestamp) &rest more-things)
  (cl:apply #'timestamp>= thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: time
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod timestamp? (thing) nil)
(defmethod timestamp? ((thing timestamp)) t)
