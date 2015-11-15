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



