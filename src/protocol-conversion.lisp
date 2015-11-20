;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-conversion.lisp
;;;; Project:       the clio language
;;;; Purpose:       type-conversion operations 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric as (type object &key &allow-other-keys))

;;; ---------------------------------------------------------------------
;;; class implementations
;;; ---------------------------------------------------------------------

(defmethod as ((type (eql 'vector)) (object cl:list) &key &allow-other-keys)
  (let* ((len (cl:length object)))
    (cl:make-array len :adjustable t :fill-pointer len :initial-contents object)))
