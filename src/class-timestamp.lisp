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

(defmethod make ((type (eql 'timestamp)) &rest initargs
                 &key (nanosecond 0 nanosecond?) (second 0 second?) (minute 0 minute?)
                   (hour 0 hour?) (day 1 day?) (month 1 month?) (year 1 year?) (timezone 0)
                   (offset 0))
  (if (not (cl:or nanosecond? second? minute? hour? day? month? year?))
      (now)
      (local-time:encode-timestamp nanosecond second minute hour day month year
                                   :timezone timezone :offset offset)))

(defmethod make ((type (eql (cl:find-class 'local-time:timestamp))) &rest initargs
                 &key (nanosecond 0 nanosecond?) (second 0 second?) (minute 0 minute?)
                   (hour 0 hour?) (day 1 day?) (month 1 month?) (year 1 year?) (timezone 0)
                   (offset 0))
  (if (not (cl:or nanosecond? second? minute? hour? day? month? year?))
      (now)
      (local-time:encode-timestamp nanosecond second minute hour day month year
                                   :timezone timezone :offset offset)))

(defun timestamp (nsec sec minute hour day month year &key timezone offset)
  (local-time:encode-timestamp nsec sec minute hour day month year
                               :timezone timezone :offset offset))


;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
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
