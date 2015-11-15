;;;; ***********************************************************************
;;;;
;;;; Name:          class-character.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the character class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; protocol: bytes
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: characters
;;; ---------------------------------------------------------------------

(defmethod alphabetical? ((char character))
  (cl:alpha-char-p char))

(defmethod alphanumeric? ((char character))
  (cl:alphanumericp char))

(defmethod char->code ((char character))
  (cl:char-code char))

(defmethod char->name ((char character))
  (cl:char-name char))

(defmethod char-downcase ((char character))
  (cl:char-downcase char))

(defmethod char-upcase ((char character))
  (cl:char-upcase char))

(defmethod character? (thing) nil)

(defmethod character? ((thing character)) t)

(defmethod code->char ((code integer))
  (cl:code-char code))

(defmethod digit-char? ((char character))
  (cl:digit-char char))

(defmethod lower-case? ((char character))
  (cl:lower-case-p char))

(defmethod name->char ((name string))
  (cl:name-char name))

(defmethod upper-case? ((char character))
  (cl:upper-case-p char))

(defmethod whitespace-char? ((char character))
  (cl:member char '(#\space #\tab #\newline #\return #\vt)))

;;; ---------------------------------------------------------------------
;;; protocol: conditions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'character)) &rest initargs
                 &key (name nil) &allow-other-keys)
  (if name
      (character name)
      (error "nil character name")))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:char= thing1 thing2 more-things))

(defmethod identical? ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: functions
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: maps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: math
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: names
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------

(defmethod < ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:char< thing1 thing2 more-things))

(defmethod <= ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:char<= thing1 thing2 more-things))

(defmethod > ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:char> thing1 thing2 more-things))

(defmethod >= ((thing1 character) (thing2 character) &rest more-things)
  (cl:apply #'cl:char>= thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: packages
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: pairs
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: streams
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: system
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: time
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------



