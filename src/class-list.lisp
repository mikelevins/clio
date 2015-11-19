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
;;; protocol: conversion
;;; ---------------------------------------------------------------------

(defmethod as ((type (eql 'vector)) (object cl:list) &key &allow-other-keys)
  (let* ((len (cl:length object)))
    (cl:make-array len :adjustable t :fill-pointer len :initial-contents object)))

;;; ---------------------------------------------------------------------
;;; protocol: copying
;;; ---------------------------------------------------------------------

(defmethod copy ((object cl:list) &key (deep t) &allow-other-keys)
  (if deep
      (cl:copy-tree object)
      (cl:mapcar 'cl:identity object)))

;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 list) (thing2 list) &rest more-things)
  (cl:apply #'cl:equal thing1 thing2 more-things))

(defmethod identical? ((thing1 list) (thing2 list) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

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
;;; protocol: mutable-maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: mutable-sequences
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: pairs
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------

;;; constructing

;;; (defgeneric add-first (thing sequence))
;;; (defgeneric add-last (sequence thing))

(defmethod append ((sequence cl:list) &rest sequences)
  (if (cl:null sequences)
      sequence
      (if (cl:null (cdr sequences))
          (cl:append sequence (car sequences))
          (cl:apply 'append
                    (cl:append sequence (car sequences))
                    (cdr sequences)))))

(defmethod binary-append ((sequence1 cl:list) (sequence2 cl:list))
  (cl:append sequence1 sequence2))

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

(defmethod filter ((test cl:function) (sequence cl:list))
  (cl:remove-if-not test sequence))

(defmethod filter ((test cl:symbol) (sequence cl:list))
  (filter (cl:symbol-function test) sequence))


(defmethod remove-duplicates ((test cl:function) (sequence cl:list))
  (cl:remove-duplicates sequence :test test))

(defmethod remove-duplicates ((test cl:symbol) (sequence cl:list))
  (remove-duplicates (cl:symbol-function test) sequence))

;;; (defgeneric remove-if (test sequence))

;;; mapping

;;; (defgeneric count-if (test sequence))

(defmethod every? ((test cl:function) (sequence cl:list))
  (cl:every test sequence))

(defmethod every? ((test cl:symbol) (sequence cl:list))
  (every? (cl:symbol-function test) sequence))

;;; (defgeneric indexes (sequence))

(defmethod map-over ((function cl:function) (sequence cl:list))
  (mapcar function sequence))

(defmethod map-over ((function cl:symbol) (sequence cl:list))
  (map-over (cl:symbol-function function) sequence))

;;; (defgeneric some? (test sequence))

;;; reducing

(defmethod reduce ((function cl:function) (sequence cl:list) &key &allow-other-keys)
  (cl:reduce function sequence :initial-value nil))

(defmethod reduce ((function cl:symbol) (sequence cl:list) &key &allow-other-keys)
  (reduce (cl:symbol-function function) sequence))

;;; indexing

;;; (defgeneric eighth (sequence))
;;; (defgeneric element (sequence index))
;;; (defgeneric fifth (sequence))

(defmethod first ((sequence cl:list))
  (cl:first sequence))

;;; (defgeneric fourth (sequence))

(defmethod last ((sequence cl:list))
  (cl:first (cl:last sequence)))

;;; (defgeneric ninth (sequence))
;;; (defgeneric penult (sequence))
;;; (defgeneric second (sequence))
;;; (defgeneric seventh (sequence))
;;; (defgeneric sixth (sequence))
;;; (defgeneric tenth (sequence))
;;; (defgeneric third (sequence))

;;; destructuring

(defmethod any ((sequence cl:list))
  (if sequence
      (cl:elt sequence
              (cl:random (cl:length sequence)))
      nil))

;;; (defgeneric by (count sequence))
;;; (defgeneric drop (count sequence))
;;; (defgeneric drop-until (test sequence))
;;; (defgeneric drop-while (test sequence))

(defmethod leave ((count cl:integer) (sequence cl:list))
  (cl:subseq sequence (- (cl:length sequence) count)))

;;; (defgeneric partition (function1 function2 sequence))

(defmethod rest ((sequence cl:list))
  (cl:rest sequence))

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

(defmethod length ((sequence list))
  (cl:length sequence))

;;; (defgeneric mismatch (sequence1 sequence2))

;;; predicates

(defmethod contains? ((sequence cl:list) value &key (test 'cl:equalp) &allow-other-keys)
  (cl:find value sequence :test test))

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

(defmethod list? (thing) nil)
(defmethod list? ((thing cl:list)) t)
