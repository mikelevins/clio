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

;;; NOTE:
;;; some Common Lisp implementations warn about defining functions on
;;; symbols exported from the CL package.  we want our own function
;;; named vector distinct from CL's, so we shadow that symbol from CL
;;; and cause it to refer to the CL class of the same name.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::vector)
           (cl:find-class 'cl::vector)))

;;; ---------------------------------------------------------------------
;;; private: vector helpers
;;; ---------------------------------------------------------------------

(defmethod %ensure-adjustable-vector (thing)
  (error "Not a vector: ~S" thing))

(defmethod %ensure-adjustable-vector ((thing cl:vector))
  (if (adjustable-array-p thing)
      (if (array-has-fill-pointer-p thing)
          thing
          (error "No fill-pointer: ~S" thing))
      (error "Not an adjustable vector: ~S" thing)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defun vector (&rest elements)
  (let* ((len (cl:length elements)))
    (cl:make-array len :adjustable t :fill-pointer len :initial-contents elements)))

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
;;; protocol: mutable-maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: mutable-sequences
;;; ---------------------------------------------------------------------

;;; mutating

(defmethod add-first! (thing (sequence cl:vector))
  (%ensure-adjustable-vector sequence)
  ;; to add something to the front of a vector we have to moved
  ;; everything to the right one first
  ;; first make room by pushing a nil onto the end
  (cl:vector-push-extend nil sequence)
  ;; now move everything to the right one
  (loop for i from (cl:1- (cl:fill-pointer sequence)) downto 1
     do (cl:setf (cl:elt sequence i)
                 (cl:elt sequence (cl:1- i))))
  ;; now put thing into the first slot
  (cl:setf (cl:elt sequence 0) thing)
  sequence)

(defmethod add-last! ((sequence cl:vector) thing)
  (%ensure-adjustable-vector sequence)
  (cl:vector-push-extend thing sequence)
  sequence)

(defmethod append! ((sequence cl:vector) &rest sequences)
  (loop for sequence2 in sequences
     do (binary-append! sequence sequence2))
  sequence)

(defmethod binary-append! ((sequence1 cl:vector) (sequence2 cl:vector))
  (%ensure-adjustable-vector sequence1)
  (let* ((len1 (cl:length sequence1))
         (len2 (cl:length sequence2)))
    (cl:adjust-array sequence1 (+ len1 len2))
    (setf (cl:fill-pointer sequence1)
          (+ len1 len2))
    (loop for i from 0 below len2
       do (progn (setf (cl:elt sequence1 (+ len1 i))
                       (cl:elt sequence2 i))))
    sequence1))

;;; (defgeneric drop! (count sequence))
;;; (defgeneric drop-until! (test sequence))
;;; (defgeneric drop-while! (test sequence))
;;; (defgeneric insert! (sequence index new-value))
;;; (defgeneric leave! (count sequence))
;;; (defgeneric remove-last! (sequence))
;;; (defgeneric replace! (sequence index new-value))
;;; (defgeneric reverse! (sequence))
;;; (defgeneric set-first! (thing sequence))
;;; (defgeneric shuffle! (sequence))
;;; (defgeneric substitute-if! (test sequence new-value))

;;; filtering
;;; (defgeneric remove-duplicates! (test sequence))
;;; (defgeneric remove-if! (test sequence))

;;; sorting

;;; (defgeneric sort! (test sequence)) ; non-destructive!

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

(defmethod element ((sequence vector) (index integer))
  (cl:elt sequence index))

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



