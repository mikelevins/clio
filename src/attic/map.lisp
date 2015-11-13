;;;; ***********************************************************************
;;;;
;;;; Name:          map.lisp
;;;; Project:       the clio language
;;;; Purpose:       finite maps 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

;;; make

(defmethod make ((type (cl:eql 'map)) &key (contents nil) &allow-other-keys)
  (fset:convert 'map
                (cl:loop for tail on contents by #'cl:cddr
                         collect (cl:cons (cl:first tail)
                                          (cl:second tail)))))

;;; as
;;; contains-key?
;;; contains-value?
;;; get
;;; keys
;;; merge
;;; put
;;; select
;;; tap
;;; vals
;;; unzipmap
;;; zipmap



