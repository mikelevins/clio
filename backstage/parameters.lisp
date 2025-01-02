;;;; ***********************************************************************
;;;;
;;;; Name:          clio.lisp
;;;; Project:       clio: an Electron presentation server for Lisp
;;;; Purpose:       system parameter definitions
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter *clio-http-server-port* nil)
(defparameter *clio-websocket-server-port* nil)
(defparameter *clio-swank-server-port* nil)
