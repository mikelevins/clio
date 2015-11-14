;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-maps.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on maps
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric binary-merge (map1 map2))
(defgeneric get (map key &key default &allow-other-keys))
(defgeneric keys (map))
(defgeneric merge (map1 map2 &rest more-maps))
(defgeneric merge (map1 map2 &rest more-maps))
(defgeneric pairs (map))
(defgeneric put (map key value))
(defgeneric select (map keys))
(defgeneric unzip (map))
(defgeneric vals (map))
(defgeneric zip (key-list value-list &key &allow-other-keys))


