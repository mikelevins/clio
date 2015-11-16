;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-taps.lisp
;;;; Project:       the clio language
;;;; Purpose:       turning data structures into streams of values
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric bytes (source &key &allow-other-keys))
(defgeneric keys (map &key &allow-other-keys))
(defgeneric lines (source &key &allow-other-keys))
(defgeneric objects (source &key &allow-other-keys))
(defgeneric random-integers (random-state &key &allow-other-keys))
(defgeneric range (start &key &allow-other-keys))
(defgeneric tap (element-type source &key &allow-other-keys))
(defgeneric vals (map &key &allow-other-keys))
(defgeneric words (source &key &allow-other-keys))

(defmethod tap ((element-type (eql :random-integers)) (source integer) &key &allow-other-keys)
  (cl:let ((iota (series:scan-range :from 0 :by 1)))
    (map-fn t (lambda (i)(random source *random-state*))
            iota)))


