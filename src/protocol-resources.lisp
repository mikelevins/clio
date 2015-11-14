;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-resources.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations files and other sources of data 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric probe (resource &key &allow-other-keys))

