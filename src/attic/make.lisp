;;;; ***********************************************************************
;;;;
;;;; Name:          make.lisp
;;;; Project:       the clio language
;;;; Purpose:       generic constructor 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defgeneric make (type &rest initargs &key &allow-other-keys))

