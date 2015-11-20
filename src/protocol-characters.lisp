;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-characters.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on text characters
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric alphabetical? (char))
(defgeneric alphanumeric? (char))
(defgeneric char->code (char))
(defgeneric char->name (char))
(defgeneric char-downcase (char))
(defgeneric char-upcase (char))
(defgeneric character? (thing))
(defgeneric code->char (code))
(defgeneric digit-char? (char))
(defgeneric lower-case? (char))
(defgeneric name->char (name))
(defgeneric upper-case? (char))
(defgeneric whitespace-char? (char))

