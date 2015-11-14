;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-series.lisp
;;;; Project:       the clio language
;;;; Purpose:       constructing and operating on series
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric collect (result-type element-type series &key &allow-other-keys))
(defgeneric range-from (start &key &allow-other-keys))
(defgeneric tap (element-type source &key &allow-other-keys))
