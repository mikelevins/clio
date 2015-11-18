;;;; ***********************************************************************
;;;;
;;;; Name:          class-stream.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the stream classes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)


;;; NOTE:
;;; some Common Lisp implementations warn about defining
;;; functions on symbols exported from the CL package.
;;; we want a generic function named stream, so we
;;; shadow that symbol from CL and cause it to refer to
;;; the CL class of the same name.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::stream)
           (cl:find-class 'cl::stream)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'stream)) &rest initargs
                 &key &allow-other-keys)
  (error "make 'stream is not yet implemented"))

(defmethod make ((type (eql (cl:find-class 'cl:stream))) &rest initargs
                 &key &allow-other-keys)
  (error "make 'stream is not yet implemented"))

(defun stream (&rest initargs &key &allow-other-keys)
  (error "the stream function is not yet implemented"))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 stream) (thing2 stream) &rest more-things)
  (error "Can't test streams for equality"))

(defmethod identical? ((thing1 stream) (thing2 stream) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: streams
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: taps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod stream? (thing) nil)
(defmethod stream? ((thing cl:stream)) t)
