;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-symbols.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on symbols
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric bound? (symbol))
(defgeneric keyword? (thing))
(defgeneric symbol? (thing))
(defgeneric unbind! (symbol))

#| exported from common-lisp and puri

gensym
intern
symbol-function
symbol-name
symbol-package
symbol-value
unintern

|#

