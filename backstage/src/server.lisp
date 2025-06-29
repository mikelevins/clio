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

(defun stop-server ()
  (hunchentoot:stop *backstage-http-server*))

(defun start-browser (&optional (url (format nil "http://localhost:~A/" *backstage-http-server-port*)))
  #+(or win32 mswindows windows)
  (uiop:run-program (format nil "explorer ~S" url))
  #+(or macos darwin)
  (uiop:run-program (format nil "open ~S" url))
  #-(or win32 mswindows macos darwin windows)
  (uiop:run-program (format nil "xdg-open ~S" url)))

#+test (start-server *backstage-http-server-port*)
#+test (stop-server)
