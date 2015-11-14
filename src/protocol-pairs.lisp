;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-pairs.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on pairs 
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

