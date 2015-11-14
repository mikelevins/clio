;;;; ***********************************************************************
;;;;
;;;; Name:          taps.lisp
;;;; Project:       the clio language
;;;; Purpose:       creating taps
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defmethod tap ((element-type (eql :random-integers)) (source integer) &key &allow-other-keys)
  (let ((iota (series:scan-range :from 0 :by 1)))
    (map-fn t (lambda (i)(random source *random-state*))
            iota)))

