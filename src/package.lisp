;;;; ***********************************************************************
;;;;
;;;; Name:          package.lisp
;;;; Project:       the clio language
;;;; Purpose:       package definitions
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

;;; ---------------------------------------------------------------------
;;; package clio-internal
;;; ---------------------------------------------------------------------
;;; the package in which clio is implemented. 

(defpackage :clio-internal
  (:use :cl :sqlite))

