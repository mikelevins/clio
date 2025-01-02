;;;; ***********************************************************************
;;;;
;;;; Name:          app.lisp
;;;; Project:       app: a sekeletal command-line app in Lisp
;;;; Purpose:       system parameter definitions
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :app)

(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter *app-http-server-port* nil)
(defparameter *app-websocket-server-port* nil)
(defparameter *app-swank-server-port* nil)
