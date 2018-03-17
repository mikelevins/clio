;;;; ***********************************************************************
;;;;
;;;; Name:          package-clio-internal.lisp
;;;; Project:       the clio language
;;;; Purpose:       private implementation package
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

;;; ---------------------------------------------------------------------
;;; package clio-internal
;;; ---------------------------------------------------------------------
;;; the package in which clio is implemented.  it imports all of
;;; common-lisp, shadowing symbols as-needed, and exporting the
;;; symbols that are part of clio

(defpackage :clio-internal
  (:use :cl :sqlite))
