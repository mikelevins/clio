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

;;; BUG: hardcode some values until dynamic lookup is working
(defparameter *backstage-http-server-port* 8080)
(defparameter *backstage-websocket-server-port* 8081)
(defparameter *backstage-swank-server-port* 5005)

(defparameter *backstage-http-server* nil)

(defun http-document-root ()
  "find the document root for the HTTP server"
  (asdf:system-relative-pathname :backstage "resources/"))
