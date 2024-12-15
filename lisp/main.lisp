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
  '((("help" #\h) :type boolean :optional t :documentation "show help message")
    (("version" #\V) :type boolean :optional t
     :documentation "if supplied then print the current version and quit")
    (("webserver-port" #\w) :type integer :optional t
     :documentation "the port on which the http UI is served; supplying it starts the http server")
    (("websocket-port" #\s) :type integer :optional t
     :documentation "the port on which the websocket server listens; supplying it starts the websocket listener")))


(defun run-clio (&key help webserver-port websocket-port version)
  (format t "~%")
  (when help (progn (command-line-arguments:show-option-help +command-line-spec+)(sb-ext:quit)))
  (when version (format t "~A~%~%" (asdf:component-version (asdf:find-system :clio)))(progn (sb-ext:quit)))
  (when webserver-port (format t "Webserver port supplied: ~A~%" webserver-port))
  (when websocket-port (format t "Websocket port supplied: ~A~%" websocket-port)))


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
