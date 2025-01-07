;;;; ***********************************************************************
;;;;
;;;; Name:          ui.lisp
;;;; Project:       backstage: an Electron presentation server for Lisp
;;;; Purpose:       HTTP UI
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :backstage)

(defun start-server (port)
  (setf *backstage-http-server*
        (make-instance 'hunchentoot:easy-acceptor
                       :port *backstage-http-server-port*
                       :document-root (http-document-root)))
  (hunchentoot:start *backstage-http-server*))

(defun stop-server (port)
  (hunchentoot:stop *backstage-http-server*))

