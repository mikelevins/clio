;;;; ***********************************************************************
;;;;
;;;; Name:          class-null.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the null class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; private: null helpers
;;; ---------------------------------------------------------------------

(defun %error-nil-is-immutable ()
  (error "nil is immutable"))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: copying
;;; ---------------------------------------------------------------------

(defmethod copy ((object cl:null) &key &allow-other-keys)
  object)

;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 null) (thing2 null) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

(defmethod identical? ((thing1 null) (thing2 null) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: mutable-sequences
;;; ---------------------------------------------------------------------

;;; mutating

(defmethod add-first! (thing (sequence cl:null))(%error-nil-is-immutable))
(defmethod add-last! ((sequence cl:null) thing)(%error-nil-is-immutable))
(defmethod append! ((sequence cl:null) &rest sequences)(%error-nil-is-immutable))
(defmethod binary-append! ((sequence1 cl:null) (sequence2 cl:null))(%error-nil-is-immutable))
(defmethod drop! (count (sequence cl:null))(%error-nil-is-immutable))
(defmethod drop-until! (test (sequence cl:null))(%error-nil-is-immutable))
(defmethod drop-while! (test (sequence cl:null))(%error-nil-is-immutable))
(defmethod insert! ((sequence cl:null) index new-value)(%error-nil-is-immutable))
(defmethod leave! (count (sequence cl:null))(%error-nil-is-immutable))
(defmethod remove-at! ((sequence cl:null) (index integer))(%error-nil-is-immutable))
(defmethod remove-last! ((sequence cl:null))(%error-nil-is-immutable))
(defmethod replace! ((sequence cl:null) index new-value)(%error-nil-is-immutable))
(defmethod reverse! ((sequence cl:null))(%error-nil-is-immutable))
(defmethod shuffle! ((sequence cl:null))(%error-nil-is-immutable))
(defmethod substitute-if! (test (sequence cl:null) new-value)(%error-nil-is-immutable))

;;; filtering
(defmethod remove-duplicates! (test (sequence cl:null))(%error-nil-is-immutable))
(defmethod remove-if! (test (sequence cl:null))(%error-nil-is-immutable))

;;; sorting

(defmethod sort! (test (sequence cl:null))(%error-nil-is-immutable)) ; non-destructive!

;;; ---------------------------------------------------------------------
;;; protocol: pairs
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------

;;; constructing

(defmethod add-first (thing (sequence cl:null))
  (cl:cons thing sequence))

(defmethod add-last ((sequence cl:null) thing)
  (cl:cons thing sequence))

(defmethod append ((sequence cl:null) &rest sequences)
  (if (cl:null sequences)
      nil
      (if (cl:null (cl:cdr sequences))
          (cl:car sequences)
          (cl:apply 'append sequences))))

(defmethod binary-append ((sequence1 cl:null) sequence2)
  sequence2)

(defmethod binary-append (sequence1 (sequence2 cl:null))
  sequence1)

(defmethod binary-append ((sequence1 cl:null) sequence2)
  sequence2)

(defmethod binary-append ((sequence1 cl:null) (sequence2 cl:null)) nil)

;;; (defgeneric collect (type series &key &allow-other-keys))
;;; (defgeneric generate (fn &key &allow-other-keys))

(defmethod interleave ((sequence1 cl:null) (sequence2 cl:null)) nil)

(defmethod interpose (thing (sequence cl:null)) nil)

(defmethod join ((sequence1 cl:null) cupola sequence2)
  (add-first cupola sequence2))

(defmethod join (sequence1 cupola (sequence2 cl:null))
  (add-last sequence1 cupola))

(defmethod reverse ((sequence cl:null)) nil)

(defmethod sequence->values ((sequence cl:null))(values))

(defmethod shuffle ((sequence cl:null)) nil)

(defmethod substitute-if ((test cl:function) (sequence cl:null) new-value) nil)

;;; (defgeneric tap (element-type source &key &allow-other-keys))

;;; filtering

(defmethod filter ((test cl:function) (sequence cl:null)) nil)

(defmethod remove-duplicates ((test cl:function) (sequence cl:null)) nil)

(defmethod remove-if ((test cl:function) (sequence cl:null)) nil)

;;; mapping

(defmethod count-if ((test cl:function) (sequence cl:null)) 0)

(defmethod every? ((test cl:function) (sequence cl:null)) t)

(defmethod indexes ((sequence cl:null)) nil)

(defmethod map-over ((function cl:function)(sequence cl:null)) nil)

(defmethod some? ((test cl:function) (sequence cl:null)) nil)

;;; reducing
(defmethod reduce ((function cl:function) (sequence cl:null) &key initial-value &allow-other-keys)
  initial-value)

;;; indexing

(defmethod eighth ((sequence cl:null))(error "index out of range"))
(defmethod element ((sequence cl:null) index)(error "index ~S out of range" index))
(defmethod fifth ((sequence cl:null))(error "index out of range"))
(defmethod first ((sequence cl:null))(error "index out of range"))
(defmethod fourth ((sequence cl:null))(error "index out of range"))
(defmethod last ((sequence cl:null))(error "index out of range"))
(defmethod ninth ((sequence cl:null))(error "index out of range"))
(defmethod penult ((sequence cl:null))(error "index out of range"))
(defmethod second ((sequence cl:null))(error "index out of range"))
(defmethod seventh ((sequence cl:null))(error "index out of range"))
(defmethod sixth ((sequence cl:null))(error "index out of range"))
(defmethod tenth ((sequence cl:null))(error "index out of range"))
(defmethod third ((sequence cl:null))(error "index out of range"))

;;; destructuring

(defmethod any ((sequence cl:null)) nil)

(defmethod by ((count cl:integer) (sequence cl:null))(error "count ~S is out of range" count))
(defmethod by ((count (eql 0)) (sequence cl:null)) nil)

(defmethod drop ((count cl:integer) (sequence cl:null))(error "count ~S is out of range" count))
(defmethod drop ((count (eql 0)) (sequence cl:null)) nil)

(defmethod drop-until ((test cl:function) (sequence cl:null)) nil)
(defmethod drop-while ((test cl:function) (sequence cl:null)) nil)

(defmethod leave ((count cl:integer) (sequence cl:null))(error "count ~S is out of range" count))
(defmethod leave ((count (eql 0)) (sequence cl:null)) nil)

(defmethod partition ((function1 cl:function) (function2 cl:function) (sequence cl:null))
  (values nil nil))

(defmethod rest ((sequence cl:null)) nil)
(defmethod split ((sequence cl:null) pivot) nil)
(defmethod subsequence ((sequence cl:null) (start cl:integer) &optional end) nil)
(defmethod tail ((sequence cl:null)) nil)
(defmethod tails ((sequence cl:null)) nil)

(defmethod take ((count cl:integer) (sequence cl:null))(error "count ~S is out of range" count))
(defmethod take ((count (eql 0)) (sequence cl:null)) nil)

(defmethod take-by ((count cl:integer) (offset cl:integer) (sequence cl:null))
    (error "count ~S is out of range" count))

(defmethod take-by ((count (eql 0)) (offset cl:integer) (sequence cl:null)) nil)

(defmethod take-until ((test cl:function) (sequence cl:null)) nil)
(defmethod take-while ((test cl:function) (sequence cl:null)) nil)

;;; properties

(defmethod length ((sequence cl:null)) nil)

(defmethod mismatch ((sequence1 cl:null) (sequence2 cl:null)) nil)

;;; predicates

(defmethod contains? ((sequence cl:null) value &key &allow-other-keys) nil)

(defmethod empty? ((sequence cl:null)) t)

(defmethod prefix-match? ((sequence1 cl:null) (sequence2 cl:null)) t)
(defmethod suffix-match? ((sequence1 cl:null) (sequence2 cl:null)) t)

;;; searching

(defmethod find-if ((test cl:function) (sequence cl:null)) nil)
(defmethod position-if ((test cl:function) (sequence cl:null)) nil)
(defmethod search ((sequence1 cl:null) (sequence2 cl:null)) nil)

;;; sorting

(defmethod sort ((test cl:function) (sequence cl:null)) nil) ; non-destructive!

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: taps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod null? (thing) nil)
(defmethod null? ((thing cl:null)) t)
