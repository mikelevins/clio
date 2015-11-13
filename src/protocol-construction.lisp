;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-construction.lisp
;;;; Project:       the clio language
;;;; Purpose:       instance-construction operations 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric make (type &rest initargs &key &allow-other-keys))
