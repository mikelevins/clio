;;;; ***********************************************************************
;;;;
;;;; Name:          class-string.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the string class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; NOTE:
;;; we want a generic function named string, so we
;;; shadow that symbol from CL and cause it to refer to
;;; the CL class of the same name.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::string)
           (cl:find-class 'cl::string)))

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

(defmethod %make-string-with-contents ((length null)(contents cl:string)
                                       &key (element-type 'cl:character))
  (cl:let ((buf (cl:make-string (cl:length contents) :element-type element-type)))
    (loop for i from 0 below (cl:length contents)
       do (setf (elt buf i)
                (elt contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents cl:sequence)
                                       &key (element-type 'cl:character))
  (assert (cl:every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (cl:let ((buf (cl:make-string (cl:length contents) :element-type element-type)))
    (loop for i from 0 below (cl:length contents)
       do (setf (elt buf i)
                (elt contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents seq)
                                       &key (element-type 'cl:character))
  (assert (fset::every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (cl:let ((buf (cl:make-string (fset:size contents) :element-type element-type)))
    (loop for i from 0 below (fset:size contents)
       do (setf (elt buf i)
                (fset:@ contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents foundation-series)
                                       &key (element-type 'cl:character))
  (cl:let ((contents* (series:collect contents)))
    (%make-string-with-contents (cl:length contents*) contents*
                                :element-type element-type)))

(defmethod %make-string-with-contents ((length integer)(contents cl:string)
                                       &key (element-type 'cl:character))
  (if (cl:eql length (cl:length contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (elt contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents cl:sequence)
                                       &key (element-type 'cl:character))
  (assert (cl:every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (if (cl:eql length (cl:length contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (elt contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents seq)
                                       &key (element-type 'cl:character))
  (assert (fset::every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (if (cl:eql length (fset:size contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (fset:@ contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents foundation-series)
                                       &key (element-type 'cl:character))
  (cl:let ((contents* (series:collect contents)))
    (%make-string-with-contents length contents*
                                :element-type element-type)))

(defmethod make ((type (eql 'string)) &rest initargs
                 &key
                   (length nil)
                   (contents nil contents?)
                   (element #\. element?)
                   (element-type 'cl:character)
                   &allow-other-keys)
  (if contents?
      (if element?
          (error "Can't specify both contents and element")
          (%make-string-with-contents length contents :element-type element-type))
      (cl:make-string length :initial-element element :element-type element-type)))

(defmethod string (thing)(error "Can't convert ~S to a string" thing))
(defmethod string ((thing cl:string)) thing)
(defmethod string ((thing cl:character)) (cl:string thing))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string= thing1 thing2 more-things))

(defmethod identical? ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

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

(defmethod < ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string< thing1 thing2 more-things))

(defmethod <= ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string<= thing1 thing2 more-things))

(defmethod > ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string> thing1 thing2 more-things))

(defmethod >= ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string>= thing1 thing2 more-things))

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

(defmethod string? (thing) nil)
(defmethod string? ((thing cl:string)) t)
