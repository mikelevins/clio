;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-pairs.lisp
;;;; Project:       the clio language
;;;; Purpose:       the pairs protocol 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; generic functions
;;; ---------------------------------------------------------------------

(defgeneric left (pair))
(defgeneric pair (left right))
(defgeneric pair? (thing))
(defgeneric right (pair))
(defgeneric set-left! (pair new-value))
(defgeneric set-right! (pair new-value))

;;; ---------------------------------------------------------------------
;;; default implementations
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'pair)) &key (left nil)(right nil) &allow-other-keys)
  (cons left right))

(defmethod as ((type (eql 'pair)) (val null) &key &allow-other-keys)
  val)

(defmethod as ((type (eql 'pair)) (val cons) &key &allow-other-keys)
  val)

(defmethod left ((pair null)) nil)

(defmethod left ((pair cons)) 
  (car pair))

(defmethod pair (l r) (cons l r))

(defmethod pair? (thing) nil)
(defmethod pair? ((thing cons)) t)

(defmethod right ((pair null)) nil)

(defmethod right ((pair cons)) 
  (cdr pair))

(defmethod set-left! ((pair cons) val) 
  (set! (car pair) val))

(defsetf left set-left!)

(defmethod set-right! ((pair cons) val) 
  (set! (cdr pair) val))

(defsetf right set-right!)
