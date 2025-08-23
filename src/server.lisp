;;;; ***********************************************************************
;;;;
;;;; Name:          ui.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       HTTP UI
;;;; Author:        mikel evins
;;;; Copyright:     2024-2025 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio)

;;; ---------------------------------------------------------------------
;;; HTTP handlers
;;; ---------------------------------------------------------------------

(hunchentoot:define-easy-handler (landing :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (landing-page))

;;; ---------------------------------------------------------------------
;;; server operations
;;; ---------------------------------------------------------------------

;;; :hunchentoot
;;; ---------------------------------------------------------------------

(in-package :hunchentoot)

;;; hunchentoot:start-listening
;;; ---------------------------------------------------------------------
;;; patched to ensure that we can reuse ports

(defmethod start-listening ((acceptor acceptor))
  (when (acceptor-listen-socket acceptor)
    (hunchentoot-error "acceptor ~A is already listening" acceptor))
  (setf (acceptor-listen-socket acceptor)
        (usocket:socket-listen (or (acceptor-address acceptor) usocket:*wildcard-host*)
                               (acceptor-port acceptor)
                               :reuseaddress t
                               :reuse-address t
                               :backlog (acceptor-listen-backlog acceptor)
                               :element-type '(unsigned-byte 8)))
  (values))

;;; :clio again
;;; ---------------------------------------------------------------------

(in-package #:clio)

(defun start-server (&key (show-lisp-errors t))
  (if show-lisp-errors
      (setf hunchentoot:*show-lisp-errors-p* t)
      (setf hunchentoot:*show-lisp-errors-p* nil))
  (if (and *clio-http-server* (listening? *clio-http-server*))
      ;; already running
      (warn "The Clio HTTP server is already running")
      ;; not running; start it up
      (progn (setf *clio-http-server*
                   (make-instance 'hunchentoot:easy-acceptor
                                  :port *clio-http-server-port*
                                  :document-root (http-document-root)))
             (hunchentoot:start *clio-http-server*)
             (setf *clio-websocket-server*
                   (trivial-ws:make-server
                    :on-connect #'(lambda (server)(format t "Connected~%"))
                    :on-disconnect #'(lambda (server)(format t "Disconnected~%"))
                    :on-message #'(lambda (server message)(handle-client-message server message))))
             (setf *clio-websocket-handler*
                   (trivial-ws:start *clio-websocket-server*
                                     *clio-websocket-port*))
             (values *clio-http-server*
                     *clio-websocket-server*))))

(defun stop-server ()
  (when (listening? *clio-http-server*)
    (hunchentoot:stop *clio-http-server*))
  (when (listening? *clio-websocket-handler*)
    (hunchentoot:stop *clio-websocket-handler*)))

(defmethod listening? ((server null)) nil)

(defmethod listening? ((server hunchentoot:acceptor))
  (and (hunchentoot::acceptor-listen-socket server) t))

(defparameter *display-client-messages* nil) 

(defun handle-client-message (server message)
  (when *display-client-messages*
    (format t "~%Received message from the browser client: ~%  ~S" message))
  (cond ((equalp message "{\"type\":\"ping\"}")
         (send-server-message "{\"type\":\"pong\"}"))
        (t (format t "Received unrecognized browser message: ~%  ~S~%" message))))

(defun send-server-message (json)
  (let ((client (first (trivial-ws:clients (websocket-server *configuration*)))))
    (trivial-ws:send client json)))

(defun start-browser (&optional (url (format nil "http://localhost:~A/" *clio-http-server-port*)))
  #+(or win32 mswindows windows)
  (uiop:run-program (format nil "explorer ~S" url))
  #+(or macos darwin)
  (uiop:run-program (format nil "open ~S" url))
  #-(or win32 mswindows macos darwin windows)
  (uiop:run-program (format nil "xdg-open ~S" url)))
