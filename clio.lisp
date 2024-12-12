;;;; ***********************************************************************
;;;;
;;;; Name:          clio.lisp
;;;; Project:       clio: an Electron presentation server for Lisp
;;;; Purpose:       server process
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter +clio-http-port+
  (find-port:find-port :min +minimum-application-port+ :max +maximum-application-port+))

(defparameter +clio-websocket-server-port+
  (find-port:find-port :min (1+ +clio-http-port+) :max +maximum-application-port+))
