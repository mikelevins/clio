;;;; ***********************************************************************
;;;;
;;;; Name:          class-list.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the list class
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

(defmethod make ((type (eql 'list)) &rest initargs
                 &key (length 0)(initial-element nil) &allow-other-keys)
  (cl:make-list length :initial-element initial-element))

(defmethod make ((type (eql (cl:find-class 'cl:list))) &rest initargs
                 &key (length 0)(initial-element nil) &allow-other-keys)
  (cl:make-list length :initial-element initial-element))

;;; function list imported from cl

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 list) (thing2 list) &rest more-things)
  (cl:apply #'cl:equal thing1 thing2 more-things))

(defmethod identical? ((thing1 list) (thing2 list) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: functions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; NOTE: the maps protocol treats Lisp lists as maps from
;;; index to value

(defmethod binary-merge ((map1 list) (map2 list))
  (let* ((len1 (cl:length map1))
         (len2 (cl:length map2)))
    (if (<= len1 len2)
        map2
        (cl:append map2
                   (cl:subseq map1 len2)))))

(defmethod get ((map list) key &key default &allow-other-keys)
  (elt map key))

(defmethod keys ((map list))
  (loop for i from 0 below (cl:length map)
     collect i))

(defmethod merge ((map1 list) (map2 list) &rest more-maps)
  (cl:reduce #'binary-merge more-maps
             :initial-value nil))

(defmethod pairs ((map list))
  (loop
     for i from 0 below (cl:length map)
     for j in map
     collect (cons i j)))

(defmethod put ((map list) (key integer) value)
  (cl:append (cl:subseq map 0 key)
             (list value)
             (cl:subseq map (cl:1+ key))))

(defmethod select ((map list) keys)
  (cl:mapcar (lambda (k)(elt map k))
             keys))

(defmethod unzip ((map list))
  (values (keys map)
          map))

(defmethod vals ((map list))
  map)

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


;;; properties

(defmethod length ((sequence list))
  (cl:length sequence))

;;; (defgeneric mismatch (sequence1 sequence2))


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

(defmethod cons? (thing) nil)
(defmethod cons? ((thing cons)) t)
