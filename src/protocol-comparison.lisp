;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-comparison.lisp
;;;; Project:       the clio language
;;;; Purpose:       comparisons of values
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric = (thing1 thing2 &rest more-things))
(defgeneric < (thing1 thing2 &rest more-things))
(defgeneric <= (thing1 thing2 &rest more-things))
(defgeneric > (thing1 thing2 &rest more-things))
(defgeneric >= (thing1 thing2 &rest more-things))

