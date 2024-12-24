;;;; ***********************************************************************
;;;;
;;;; Name:          main.lisp
;;;; Project:       clio: an Electron presentation server for Lisp
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
    (("swank-server-port" #\s) :type integer :optional t
     :documentation "the port on which the Lisp swank server listens; starts the swank server")
    (("http-server-port" #\H) :type integer :optional t
     :documentation "the port on which the http UI is served; starts the HTTP server")
    (("websocket-server-port" #\w) :type integer :optional t
     :documentation "the port on which the websocket server listens; starts the websocket server")))

(defparameter *swank-server* nil)

(defun run-swank-server (port)
  (let ((server-port (cond ((integerp port) port)
                           ((stringp port) (parse-integer port))
                           (t (error "Invalid swank port: ~S" port)))))
    (format t "Starting swank server on port ~A~%" server-port)
    (setf *swank-server* (swank:create-server :port server-port))))

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


(defun run-clio (&key help swank-server-port http-server-port websocket-server-port version)
  (format t "~%")
  (when help (progn (command-line-arguments:show-option-help +command-line-spec+)(sb-ext:quit)))
  (when version (format t "~A~%~%" (asdf:component-version (asdf:find-system :clio)))(progn (sb-ext:quit)))
  (when swank-server-port (run-swank-server swank-server-port))
  (when http-server-port (run-http-server http-server-port))
  (when websocket-server-port (run-websocket-server websocket-server-port))
  (when (or swank-server-port
            http-server-port
            websocket-server-port)
    (sb-impl::toplevel-init)))


;;; FUNCTION main
;;; ---------------------------------------------------------------------
;;; the main entry point of the clio Lisp process. Handles
;;; command-line arguments and runs the chosen subsystems, then exits.

(defun main ()
  (let ((args (uiop:command-line-arguments)))
    (if args
        (handler-case (command-line-arguments:handle-command-line +command-line-spec+
                                                                  'run-clio
                                                                  :name "clio"
                                                                  :command-line args)
          (error (err)
            (command-line-arguments:show-option-help +command-line-spec+)))
        (command-line-arguments:show-option-help +command-line-spec+))
    (cl-user::quit)))
