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

;;; (defgeneric add-first (thing sequence))
;;; (defgeneric add-last (sequence thing))
;;; (defgeneric any (sequence))
;;; (defgeneric append (sequence &rest sequences))
;;; (defgeneric binary-append (sequence1 sequence2))
;;; (defgeneric by (count sequence))
;;; (defgeneric collect (type series &key &allow-other-keys))
;;; (defgeneric count-if (test sequence))

(defmethod drop ((count integer)(sequence foundation-series))
  (series:subseries sequence count))

;;; (defgeneric drop-until (test sequence))
;;; (defgeneric drop-while (test sequence))
;;; (defgeneric eighth (sequence))
;;; (defgeneric element (sequence index))
;;; (defgeneric empty? (sequence))
;;; (defgeneric every? (test sequence))
;;; (defgeneric fifth (sequence))
;;; (defgeneric filter (test sequence))
;;; (defgeneric find-if (test sequence))
;;; (defgeneric first (sequence))
;;; (defgeneric fourth (sequence))
;;; (defgeneric generate (fn &key &allow-other-keys))
;;; (defgeneric indexes (sequence))
;;; (defgeneric interleave (sequence1 sequence2))
;;; (defgeneric interpose (thing sequence))
;;; (defgeneric join (sequence1 cupola sequence2))
;;; (defgeneric last (sequence))
;;; (defgeneric leave (count sequence))
;;; (defgeneric length (sequence))
;;; (defgeneric map-over (function sequence))
;;; (defgeneric mismatch (sequence1 sequence2))
;;; (defgeneric ninth (sequence))
;;; (defgeneric partition (function1 function2 sequence))
;;; (defgeneric penult (sequence))
;;; (defgeneric position-if (test sequence))
;;; (defgeneric prefix-match? (sequence1 sequence2))
;;; (defgeneric range (start-index below-index))
;;; (defgeneric reduce (function sequence))
;;; (defgeneric remove-duplicates (test sequence))
;;; (defgeneric remove-if (test sequence))
;;; (defgeneric rest (sequence))
;;; (defgeneric reverse (sequence))
;;; (defgeneric search (sequence))
;;; (defgeneric second (sequence))
;;; (defgeneric sequence->values (sequence))
;;; (defgeneric seventh (sequence))
;;; (defgeneric shuffle (sequence))
;;; (defgeneric sixth (sequence))
;;; (defgeneric some? (test sequence))
;;; (defgeneric sort (test sequence)) ; non-destructive!
;;; (defgeneric split (sequence pivot))
;;; (defgeneric subsequence (sequence start &optional end))
;;; (defgeneric substitute-if (test sequence new-value))
;;; (defgeneric suffix-match? (sequence1 sequence2))
;;; (defgeneric tail (sequence))
;;; (defgeneric tails (sequence))

(defmethod take ((count integer) (sequence foundation-series))
  (series:subseries sequence 0 count))

;;; (defgeneric take-by (count offset sequence))
;;; (defgeneric take-until (test sequence))
;;; (defgeneric take-while (test sequence))
;;; (defgeneric tap (element-type source &key &allow-other-keys))
;;; (defgeneric tenth (sequence))
;;; (defgeneric third (sequence))

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

