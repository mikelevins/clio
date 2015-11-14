;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-functions.lisp
;;;; Project:       the clio language
;;;; Purpose:       creating and operating on functions
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric fbound? (symbol))
(defgeneric funbind! (symbol))
(defgeneric function? (thing))

#| exported from common-lisp

;; functions

apply
complement
constantly
funcall
identity
not
values

;; special forms and macros

|#
