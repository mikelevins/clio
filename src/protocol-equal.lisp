;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-equal.lisp
;;;; Project:       the clio language
;;;; Purpose:       equivalence of values
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric = (thing1 thing2 &rest more-things))
(defgeneric identical? (thing1 thing2 &rest more-things))

