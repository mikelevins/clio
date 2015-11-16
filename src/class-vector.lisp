;;;; ***********************************************************************
;;;;
;;;; Name:          class-vector.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the vector class
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
;;; protocol: conditions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod %make-vector-with-contents ((length null)(contents cl:sequence)
                                       &key element-type)
  (cl:make-array (cl:length contents) :initial-contents contents :element-type element-type
                 :adjustable t :fill-pointer (cl:length contents)))

(defmethod %make-vector-with-contents ((length null)(contents seq)
                                       &key element-type)
  (%make-vector-with-contents length (fset:convert 'cl:list contents)
                              :element-type element-type))

(defmethod %make-vector-with-contents ((length null)(contents foundation-series)
                                       &key element-type)
  (%make-vector-with-contents length (series:collect 'cl:list contents)
                              :element-type element-type))

(defmethod %make-vector-with-contents ((length integer)(contents sequence)
                                       &key element-type)
  (cl:let ((size (cl:length contents)))
    (if (cl:equal size length)
        (cl:make-array size :initial-contents contents :element-type element-type
                       :adjustable t :fill-pointer size)
        (error "length ~S is not equal to the length of ~S"
               size contents))))

(defmethod %make-vector-with-contents ((length integer)(contents seq)
                                       &key element-type)
  (%make-vector-with-contents length (fset:convert 'cl:list contents)
                              :element-type element-type))

(defmethod %make-vector-with-contents ((length integer)(contents foundation-series)
                                       &key element-type)
  (%make-vector-with-contents length (series:collect 'cl:list contents)
                              :element-type element-type))

(defmethod make ((type (eql 'vector)) &rest initargs
                 &key
                   (length nil)
                   (contents nil contents?)
                   (element #\. element?)
                   (element-type t)
                   &allow-other-keys)
  (if contents?
      (if element?
          (error "Can't specify both contents and element")
          (%make-vector-with-contents length contents :element-type element-type))
      (cl:make-array length :initial-element element :element-type element-type
                     :adjustable t :fill-pointer length)))

(defmethod make ((type (eql (cl:find-class 'cl:vector))) &rest initargs
                 &key
                   (length nil)
                   (contents nil contents?)
                   (element #\. element?)
                   (element-type t)
                   &allow-other-keys)
  (if contents?
      (if element?
          (error "Can't specify both contents and element")
          (%make-vector-with-contents length contents :element-type element-type))
      (cl:make-array length :initial-element element :element-type element-type
                     :adjustable t :fill-pointer length)))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 vector) (thing2 vector) &rest more-things)
  (if (cl:equalp thing1 thing2)
      (if more-things
          (cl:apply #'= thing2 more-things)
          t)
      nil))

(defmethod identical? ((thing1 vector) (thing2 vector) &rest more-things)
  (if (cl:eq thing1 thing2)
      (if more-things
          (cl:apply #'= thing2 more-things)
          t)
      nil))

;;; ---------------------------------------------------------------------
;;; protocol: functions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: math
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: names
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: packages
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: pairs
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: streams
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: system
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: time
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------



