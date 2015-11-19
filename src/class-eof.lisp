;;;; ***********************************************************************
;;;;
;;;; Name:          class-eof.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the eof class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defclass eof (cl-singleton-mixin:singleton-mixin)())

(defmethod print-object ((thing eof)(out cl:stream))
  (print-unreadable-object (thing out :type t :identity nil)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defun eof ()(make 'eof))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod eof? (thing) nil)
(defmethod eof? ((thing eof)) t)


