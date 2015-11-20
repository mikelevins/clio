;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-serialization.lisp
;;;; Project:       the clio language
;;;; Purpose:       serializing and deserializing Clio data
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric serialize (object place))
(defgeneric deserialize (place))

