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


(defun run-clio (&key help swank-server-port http-server-port websocket-server-port version)
  (format t "~%")
  (when help (progn (command-line-arguments:show-option-help +command-line-spec+)(sb-ext:quit)))
  (when version (format t "~A~%~%" (asdf:component-version (asdf:find-system :clio)))(progn (sb-ext:quit)))
  (when swank-server-port (format t "swank server port supplied: ~A~%" swank-server-port))
  (when http-server-port (format t "HTTP server port supplied: ~A~%" http-server-port))
  (when websocket-server-port (format t "Websocket port supplied: ~A~%" websocket-server-port)))


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
