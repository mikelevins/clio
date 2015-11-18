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

(defmethod make ((type (eql 'eof)) &rest initargs
                 &key &allow-other-keys)
  (make-instance 'eof))

(defmethod make ((type (eql (cl:find-class 'eof))) &rest initargs
                 &key &allow-other-keys)
  (make-instance 'eof))

(defun eof ()(make-instance 'eof))

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


