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

(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf (symbol-function 'clio-internal::make)
        (symbol-function 'cl::make-instance)))
