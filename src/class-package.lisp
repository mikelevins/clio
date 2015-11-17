;;;; ***********************************************************************
;;;;
;;;; Name:          class-package.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the package class
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
;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------
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

(defmethod package? (thing) nil)
(defmethod package? ((thing cl:package)) t)
