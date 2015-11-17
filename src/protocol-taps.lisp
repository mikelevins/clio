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

;; (defmacro repeat (expr) ) ; creates a series of values by repeatedly evaluating expr

(defgeneric tap (element-type source &key &allow-other-keys))

;;; ---------------------------------------------------------------------
;;; tap types:
;;; ---------------------------------------------------------------------
;;; :bytes (of a byte input)
;;; :keys (of a map)
;;; :lines (of a text)

(defmethod tap ((element-type (eql :lines)) (source stream) &key &allow-other-keys)
  (loop for line = (cl:read-line source nil nil nil) then (cl:read-line source nil nil nil)
     while line
     collect line))

(defmethod tap ((element-type (eql :lines)) (source uri) &key &allow-other-keys)
  (with-open-file (in (uri-path source)
                      :direction :input
                      :element-type 'cl:character)
    (tap :lines in)))

;;; :objects (of a character input)
;;; :random-integers

(defmethod tap ((element-type (eql :random-integers)) (source integer) &key &allow-other-keys)
  (cl:let ((iota (series:scan-range :from 0 :by 1)))
    (map-fn t (lambda (i)(random source *random-state*))
            iota)))

;;; :range (of a numeric type)
;;; :values (of a map)
;;; :words (of a text)


