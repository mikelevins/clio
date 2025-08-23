;;;; ***********************************************************************
;;;;
;;;; Name:          clio.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       system parameter definitions
;;;; Author:        mikel evins
;;;; Copyright:     2024-2025 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defparameter *clio-delivered-p* nil)


(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter *clio-http-server-port* 8080)
(defparameter *clio-websocket-port* 40404)
(defparameter *clio-swank-server-port* 5005)

(defparameter *clio-http-server* nil)
(defparameter *clio-websocket-server* nil)
(defparameter *clio-websocket-handler* nil)

(defun http-document-root ()
  "find the document root for the HTTP server"
  (asdf:system-relative-pathname :clio "public/"))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf cl-who:*attribute-quote-char* #\"))

