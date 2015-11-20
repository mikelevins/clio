;;;; ***********************************************************************
;;;;
;;;; Name:          class-map.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the map class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defun map (&rest contents)
  (fset:convert 'map
                (loop for tail on contents by #'cddr
                   collect (cons (cl:first tail)
                                 (cl:second tail)))))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: copying
;;; ---------------------------------------------------------------------

(defmethod copy ((object map) &key (deep t) &allow-other-keys)
  (if deep
      (let* ((keys (keys object))
             (vals (cl:mapcar (lambda (val)(copy val :deep t))
                              (vals object))))
        (zip keys vals))
      (let* ((keys (keys object))
             (vals (vals object)))
        (zip keys vals))))

;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 map) (thing2 map) &rest more-things)
  (if (fset:equal? thing1 thing2)
      (if more-things
          (cl:apply #'= thing2 more-things)
          t)
      nil))

(defmethod identical? ((thing1 map) (thing2 map) &rest more-things)
  (if (eq thing1 thing2)
      (if more-things
          (cl:apply #'identical? thing2 more-things)
          t)
      nil))

;;; ---------------------------------------------------------------------
;;; protocol: functions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------

(defmethod binary-merge ((map1 map) (map2 map))
  (fset:map-union map1 map2))

(defmethod get ((map map) key &key default &allow-other-keys)
  (multiple-value-bind (found found?)(fset:@ map key)
    (if found? found default)))

(defmethod keys ((map map))
  (fset:convert 'list (fset:domain map)))

(defmethod merge ((map1 map) (map2 map) &rest more-maps)
  (cl:reduce #'binary-merge more-maps
             :initial-value (binary-merge map1 map2)))

(defmethod pairs ((map map))
  (fset:convert 'list map))

(defmethod put ((map map) key value)
  (fset:with map key value))

(defmethod select ((map map) keys)
  (fset:restrict map (fset:convert 'fset:set keys)))

(defmethod unzip ((map map))
  (cl:values (fset:convert 'list (fset:domain map))
             (fset:convert 'list (fset:range map))))

(defmethod vals ((map map))
  (cl:mapcar (lambda (k)(get map k))
             (keys map)))

(defmethod zip ((key-list cl:sequence) (value-list cl:sequence) &key &allow-other-keys)
  (fset:convert 'map
                (cl:mapcar (lambda (k v)(cons k v))
                           key-list
                           value-list)))

;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------

;;; constructing

;;; (defgeneric add-first (thing sequence))
;;; (defgeneric add-last (sequence thing))
;;; (defgeneric append (sequence &rest sequences))
;;; (defgeneric binary-append (sequence1 sequence2))
;;; (defgeneric collect (type series &key &allow-other-keys))
;;; (defgeneric generate (fn &key &allow-other-keys))
;;; (defgeneric interleave (sequence1 sequence2))
;;; (defgeneric interpose (thing sequence))
;;; (defgeneric join (sequence1 cupola sequence2))
;;; (defgeneric reverse (sequence))
;;; (defgeneric sequence->values (sequence))
;;; (defgeneric shuffle (sequence))
;;; (defgeneric substitute-if (test sequence new-value))
;;; (defgeneric tap (element-type source &key &allow-other-keys))

;;; filtering
;;; (defgeneric filter (test sequence))
;;; (defgeneric remove-duplicates (test sequence))
;;; (defgeneric remove-if (test sequence))

;;; mapping

;;; (defgeneric count-if (test sequence))
;;; (defgeneric every? (test sequence))
;;; (defgeneric indexes (sequence))
;;; (defgeneric map-over (function sequence))
;;; (defgeneric some? (test sequence))

;;; reducing
;;; (defgeneric reduce (function sequence &key &allow-other-keys))

;;; indexing

;;; (defgeneric eighth (sequence))
;;; (defgeneric element (sequence index))
;;; (defgeneric fifth (sequence))
;;; (defgeneric first (sequence))
;;; (defgeneric fourth (sequence))
;;; (defgeneric last (sequence))
;;; (defgeneric ninth (sequence))
;;; (defgeneric penult (sequence))
;;; (defgeneric second (sequence))
;;; (defgeneric seventh (sequence))
;;; (defgeneric sixth (sequence))
;;; (defgeneric tenth (sequence))
;;; (defgeneric third (sequence))

;;; destructuring

;;; (defgeneric any (sequence))
;;; (defgeneric by (count sequence))
;;; (defgeneric drop (count sequence))
;;; (defgeneric drop-until (test sequence))
;;; (defgeneric drop-while (test sequence))
;;; (defgeneric leave (count sequence))
;;; (defgeneric partition (function1 function2 sequence))
;;; (defgeneric rest (sequence))
;;; (defgeneric split (sequence pivot))
;;; (defgeneric subsequence (sequence start &optional end))
;;; (defgeneric tail (sequence))
;;; (defgeneric tails (sequence))
;;; (defgeneric take (count sequence))
;;; (defgeneric take-by (count offset sequence))
;;; (defgeneric take-until (test sequence))
;;; (defgeneric take-while (test sequence))

;;; properties

;;; (defgeneric length (sequence))
;;; (defgeneric mismatch (sequence1 sequence2))

;;; predicates

;;; (defgeneric contains? (sequence value &key &allow-other-keys))
;;; (defgeneric empty? (sequence))
;;; (defgeneric prefix-match? (sequence1 sequence2))
;;; (defgeneric suffix-match? (sequence1 sequence2))

;;; searching

;;; (defgeneric find-if (test sequence))
;;; (defgeneric position-if (test sequence))
;;; (defgeneric search (sequence))

;;; sorting

;;; (defgeneric sort (test sequence)) ; non-destructive!

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: taps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod map? (thing) nil)
(defmethod map? ((thing map)) t)
