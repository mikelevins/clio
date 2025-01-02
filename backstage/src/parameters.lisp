;;;; ***********************************************************************
;;;;
;;;; Name:          backstage.lisp
;;;; Project:       backstage: an Electron presentation server for Lisp
;;;; Purpose:       system parameter definitions
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :backstage)

(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter *backstage-http-server-port* nil)
(defparameter *backstage-websocket-server-port* nil)
(defparameter *backstage-swank-server-port* nil)
