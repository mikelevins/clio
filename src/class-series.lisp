;;;; ***********************************************************************
;;;;
;;;; Name:          class-series.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the foundation-series class
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

(defmethod %make-series-with-contents ((contents cl:sequence))
  (series:scan contents))

(defmethod %make-series-with-contents ((contents seq))
  (series:scan (fset:convert 'cl:list contents)))

;;; (make 'series :range :from 0 :to 100 :by 2)
;;; (make 'series :range :from 0 :by -1)
(defmethod %make-series-with-range ((from integer) to by)
  (if to
      (if (> to from)
          (if by
              (cl:let ((by (if (plusp by) by (- by))))
                (series:scan-range :from from :below to :by by))
              (series:scan-range :from from :below to))
          (if by
              (cl:let ((by (if (minusp by) by (- by))))
                (series:scan-range :from from :above to :by by))
              (series:scan-range :from from :above to)))
      (if by
          (series:scan-range :from from :by by)
          (series:scan-range :from from))))

(defmethod make ((type (eql 'series)) &rest initargs
                 &key
                   (contents nil contents?)
                   (from nil from?)
                   (to nil)
                   (by nil)
                   &allow-other-keys)
  (cond
    (contents? (assert (not from?)() "Cannot specify both contents and range")
               (%make-series-with-contents contents))
    (from? (assert (not contents?)() "Cannot specify both contents and range")
           (cl:let ((from (getf initargs :from nil))
                    (to (getf initargs :to nil))
                    (by (getf initargs :by nil)))
             (%make-series-with-range from to by)))
    (t (error "You must specify either a contents or a from argument to make 'series"))))

(defmethod make ((type (eql 'foundation-series)) &rest initargs
                 &key
                   (contents nil contents?)
                   (from nil from?)
                   (to nil)
                   (by nil)
                   &allow-other-keys)
  (cond
    (contents? (assert (not from?)() "Cannot specify both contents and range")
               (%make-series-with-contents contents))
    (from? (assert (not contents?)() "Cannot specify both contents and range")
           (cl:let ((from (getf initargs :from nil))
                    (to (getf initargs :to nil))
                    (by (getf initargs :by nil)))
             (%make-series-with-range from to by)))
    (t (error "You must specify either a contents or a from argument to make 'series"))))

(defmethod make ((type (eql (cl:find-class 'series::foundation-series))) &rest initargs
                 &key
                   (contents nil contents?)
                   (from nil from?)
                   (to nil)
                   (by nil)
                   &allow-other-keys)
  (cond
    (contents? (assert (not from?)() "Cannot specify both contents and range")
               (%make-series-with-contents contents))
    (from? (assert (not contents?)() "Cannot specify both contents and range")
           (cl:let ((from (getf initargs :from nil))
                    (to (getf initargs :to nil))
                    (by (getf initargs :by nil)))
             (%make-series-with-range from to by)))
    (t (error "You must specify either a contents or a from argument to make 'series"))))

(defun series (&rest contents)
  (make 'series :contents contents))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 foundation-series) (thing2 foundation-series) &rest more-things)
  (error "Can't test possibly-infinite sequences for equality"))

(defmethod identical? ((thing1 foundation-series) (thing2 foundation-series) &rest more-things)
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
;;; ---------------------------------------------------------------------
;;; protocol: packages
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

(defmethod drop ((count integer)(sequence foundation-series))
  (series:subseries sequence count))

(defmethod take ((count integer) (sequence foundation-series))
  (series:subseries sequence 0 count))

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

(defmethod series? (thing) nil)
(defmethod series? ((thing foundation-series)) t)

