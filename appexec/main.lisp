;;;; ***********************************************************************
;;;;
;;;; Name:          main.lisp
;;;; Project:       appsexec: a skeletal command-line app in Lisp
;;;; Purpose:       main lisp process
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(defparameter +command-line-spec+
  '((("help" #\h) :type boolean :optional t :documentation "print a help message and quit")
    (("version" #\V) :type boolean :optional t
     :documentation "print the current version and quit")
    (("http-server-port" #\H) :type integer :optional t
     :documentation "the port on which the http UI is served; starts the HTTP server")
    (("websocket-server-port" #\w) :type integer :optional t
     :documentation "the port on which the websocket server listens; starts the websocket server")))

(defparameter *http-server* nil)

(defun run-http-server (port)
  (setf *http-server* (make-instance 'hunchentoot:easy-acceptor :port port))
  (hunchentoot:start *http-server*)
  *http-server*)

(defun stop-http-server ()
  (hunchentoot:stop *http-server*)
  *http-server*)

(defparameter *websocket-server* nil)

(defun handle-websocket-message (server message)
  (cond (t (format t "Received (~S): ~A~%" server message))))

(defun run-websocket-server (port)
  (setf *websocket-server*
        (trivial-ws:make-server
         :on-connect #'(lambda (server)(format t "Connected~%"))
         :on-disconnect #'(lambda (server)(format t "Disconnected~%"))
         :on-message #'(lambda (server message)(handle-websocket-message server message))))
  (trivial-ws:start *websocket-server* port))


(defun run-app (&key help http-server-port websocket-server-port version)
  (format t "~%")
  (when help (progn (command-line-arguments:show-option-help +command-line-spec+)(sb-ext:quit)))
  (when version (format t "~A~%~%" (asdf:component-version (asdf:find-system :appexec)))(progn (sb-ext:quit)))
  (when http-server-port (run-http-server http-server-port))
  (when websocket-server-port (run-websocket-server websocket-server-port))
  (when (or http-server-port
            websocket-server-port)
    (sb-impl::toplevel-init)))


;;; FUNCTION main
;;; ---------------------------------------------------------------------
;;; the main entry point of the app Lisp process. Handles
;;; command-line arguments and runs the chosen subsystems, then exits.

(defun main ()
  (let ((args (uiop:command-line-arguments)))
    (if args
        (handler-case (command-line-arguments:handle-command-line +command-line-spec+
                                                                  'run-app
                                                                  :name "app"
                                                                  :command-line args)
          (error (err)
            (command-line-arguments:show-option-help +command-line-spec+)))
        (command-line-arguments:show-option-help +command-line-spec+))
    (cl-user::quit)))
