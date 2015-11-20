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

(defun hash-table (&key (test '=) &allow-other-keys)
  (make 'hash-table :test test))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: copying
;;; ---------------------------------------------------------------------

(defmethod copy ((object cl:hash-table) &key (deep t) &allow-other-keys)
  (let* ((copy (make-hash-table :test (hash-table-test object)
                                :size (hash-table-size object)
                                :rehash-size (hash-table-rehash-size object)
                                :rehash-threshold (hash-table-rehash-threshold object))))
    (if deep
        (loop for key being the hash-keys of object
           do (setf (gethash key copy)
                    (copy (gethash key object) :deep t)))
        (loop for key being the hash-keys of object
           do (setf (gethash key copy)
                    (gethash key object))))
    copy))

;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: mutable-maps
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
