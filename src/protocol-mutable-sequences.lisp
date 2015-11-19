;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-mutable-sequences.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on mutable sequences 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)


;;; mutating

(defgeneric add-first! (thing sequence))
(defgeneric add-last! (sequence thing))
(defgeneric append! (sequence &rest sequences))
(defgeneric binary-append! (sequence1 sequence2))
(defgeneric drop! (count sequence))
(defgeneric drop-until! (test sequence))
(defgeneric drop-while! (test sequence))
(defgeneric insert! (sequence index new-value))
(defgeneric leave! (count sequence))
(defgeneric remove-last! (sequence))
(defgeneric replace! (sequence index new-value))
(defgeneric reverse! (sequence))
(defgeneric set-first! (thing sequence))
(defgeneric shuffle! (sequence))
(defgeneric substitute-if! (test sequence new-value))

;;; filtering
(defgeneric remove-duplicates! (test sequence))
(defgeneric remove-if! (test sequence))

;;; sorting

(defgeneric sort! (test sequence)) ; non-destructive!

