;;;; ***********************************************************************
;;;;
;;;; Name:          pair.lisp
;;;; Project:       the clio language
;;;; Purpose:       clio pair types 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defmethod make ((type (cl:eql 'pair)) &key (left nil)(right nil) &allow-other-keys)
  (cl:cons left right))

(defmethod as ((type (cl:eql 'pair)) (val cl:null) &key &allow-other-keys)
  val)

(defmethod as ((type (cl:eql 'pair)) (val cl:cons) &key &allow-other-keys)
  val)

(defmethod left ((val cl:null)) nil)

(defmethod left ((val cl:cons)) 
  (cl:car val))

(defmethod pair (l r) (cl:cons l r))

(defmethod right ((val cl:null)) nil)

(defmethod right ((val cl:cons)) 
  (cl:cdr val))

(defmethod set-left! ((p cl:cons) val) 
  (set! (cl:car p) val))

(cl:defsetf left set-left!)

(defmethod set-right! ((p cl:cons) val) 
  (set! (cl:cdr p) val))

(cl:defsetf right set-right!)

