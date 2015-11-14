;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-streams.lisp
;;;; Project:       the clio language
;;;; Purpose:       constructing and operating on streams
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric bytes (source &key &allow-other-keys))
(defgeneric characters (source &key &allow-other-keys))
(defgeneric close (stream &key &allow-other-keys))
(defgeneric lines (source &key &allow-other-keys))
(defgeneric objects (source &key &allow-other-keys))
(defgeneric open (resource &key &allow-other-keys))
(defgeneric read (source &key &allow-other-keys))
(defgeneric with-open (resource &key &allow-other-keys))
(defgeneric words (source &key &allow-other-keys))
(defgeneric write (stream &key &allow-other-keys))

