;;;; ***********************************************************************
;;;;
;;;; Name:          class-hash-table.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the hash-table class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)


;;; NOTE:
;;; some Common Lisp implementations warn about defining
;;; functions on symbols exported from the CL package.
;;; we want a generic function named hash-table, so we
;;; shadow that symbol from CL and cause it to refer to
;;; the CL class of the same name.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::hash-table)
           (cl:find-class 'cl::hash-table)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'hash-table)) &rest initargs
                 &key (test '=) &allow-other-keys)
  (cl:let ((test-name (case test
                        (= 'cl:equal)
                        (identical? 'cl:eq)
                        (equivalent? 'cl:eql)
                        (t (error "The test argument to make 'hash-table must be =, equivalent?, or identical?")))))
    (make-hash-table :test test-name)))

(defmethod make ((type (eql (cl:find-class 'cl:hash-table))) &rest initargs
                 &key (test '=) &allow-other-keys)
  (cl:let ((test-name (case test
                        (= 'cl:equal)
                        (identical? 'cl:eq)
                        (equivalent? 'cl:eql)
                        (t (error "The test argument to make 'hash-table must be =, equivalent?, or identical?")))))
    (make-hash-table :test test-name)))

(defun hash-table (&key (test '=) &allow-other-keys)
  (make 'hash-table :test test))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: taps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod hash-table? (thing) nil)
(defmethod hash-table? ((thing hash-table)) t)
