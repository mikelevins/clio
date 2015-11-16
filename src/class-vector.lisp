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
;;; NOTE: the maps protocol treats Lisp vectors as maps from
;;; index to value

(defmethod binary-merge ((map1 vector) (map2 vector))
  (let* ((len1 (cl:length map1))
         (len2 (cl:length map2)))
    (if (<= len1 len2)
        map2
        (cl:concatenate 'vector
                        map2
                        (cl:subseq map1 len2)))))

(defmethod get ((map vector) key &key default &allow-other-keys)
  (elt map key))

(defmethod keys ((map vector))
  (loop for i from 0 below (cl:length map)
     collect i))

(defmethod merge ((map1 vector) (map2 vector) &rest more-maps)
  (cl:reduce #'binary-merge more-maps
             :initial-value (binary-merge map1 map2)))

(defmethod pairs ((map vector))
  (loop
     for i from 0 below (cl:length map)
     for j across map
     collect (cons i j)))

(defmethod put ((map vector) (key integer) value)
  (let* ((new-vec (cl:make-array (cl:length map))))
    (loop for i from 0 below (cl:length map)
       do (setf (elt new-vec i)
                (elt map i)))
    (setf (elt new-vec key) value)
    new-vec))

(defmethod select ((map vector) keys)
  (cl:map 'cl:vector
          (lambda (k)(elt map k))
          keys))

(defmethod unzip ((map vector))
  (values (keys map)
          (cl:coerce map 'cl:list)))

(defmethod vals ((map vector))
  (cl:coerce map 'cl:list))

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



