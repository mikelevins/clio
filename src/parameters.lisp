;;;; ***********************************************************************
;;;;
;;;; Name:          parameters.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       system parameter definitions
;;;; Author:        mikel evins
;;;; Copyright:     2024-2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(defparameter *clio-delivered-p* nil)


(defparameter +minimum-application-port+ 49152)
(defparameter +maximum-application-port+ 65535)

(defparameter *clio-server-port* 8080)
(defparameter *clio-swank-server-port* 5005)

(defparameter *clio-server* nil)
(defparameter *clio-ws-resource* nil)

;;; *handler-initializers* holds the names (symbols) of the
;;; zero-argument functions that populate *MESSAGE-HANDLERS* with
;;; Clio's built-in message handlers. It lives here rather than
;;; alongside *MESSAGE-HANDLERS* in server.lisp so that it survives a
;;; single-file reload of server.lisp. On such a reload, the
;;; defparameter at the top of server.lisp wipes *MESSAGE-HANDLERS*
;;; but *HANDLER-INITIALIZERS* (defined here) still holds every
;;; contributing file's initializer name. The trailing
;;; (INITIALIZE-HANDLERS) form at the bottom of server.lisp then
;;; restores the complete handler table -- not just the handlers that
;;; server.lisp itself owns. See REGISTER-HANDLER-INITIALIZER and
;;; INITIALIZE-HANDLERS in server.lisp.

(defparameter *handler-initializers* '())

(defun http-document-root ()
  "find the document root for the HTTP server"
  (asdf:system-relative-pathname :clio "public/"))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (setf cl-who:*attribute-quote-char* #\"))

