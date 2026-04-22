;;;; ***********************************************************************
;;;;
;;;; Name:          server.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       Clio application server
;;;; Author:        mikel evins
;;;; Copyright:     2024-2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio)

;;; ---------------------------------------------------------------------
;;; acceptor
;;; ---------------------------------------------------------------------
;;; clio-acceptor inherits from both hunchensocket:websocket-acceptor
;;; (so that WebSocket upgrade requests are intercepted and dispatched
;;; through hunchensocket) and hunchentoot:easy-acceptor (so that
;;; define-easy-handler and document-root static file serving continue
;;; to work). Ordinary requests fall through to easy-acceptor's
;;; dispatch; upgrade requests are handled by websocket-acceptor.

(defclass clio-acceptor (hunchensocket:websocket-acceptor
                         hunchentoot:easy-acceptor)
  ())

;;; start-listening specialized on clio-acceptor, replacing the former
;;; cross-package monkey-patch on hunchentoot:acceptor. The socket is
;;; opened with SO_REUSEADDR so that restarts during development don't
;;; fail with "address in use".

(defmethod hunchentoot:start-listening ((acceptor clio-acceptor))
  (when (hunchentoot::acceptor-listen-socket acceptor)
    (hunchentoot::hunchentoot-error "acceptor ~A is already listening" acceptor))
  (setf (hunchentoot::acceptor-listen-socket acceptor)
        (usocket:socket-listen (or (hunchentoot:acceptor-address acceptor)
                                   usocket:*wildcard-host*)
                               (hunchentoot:acceptor-port acceptor)
                               :reuseaddress t
                               :reuse-address t
                               :backlog (hunchentoot::acceptor-listen-backlog acceptor)
                               :element-type '(unsigned-byte 8)))
  (values))

;;; ---------------------------------------------------------------------
;;; websocket resource
;;; ---------------------------------------------------------------------
;;; A single clio-ws-resource instance is bound to the /ws path and
;;; serves every connected client.

(defclass clio-ws-resource (hunchensocket:websocket-resource)
  ())

(defun find-ws-resource (request)
  (when (equal (hunchentoot:script-name request) "/ws")
    *clio-ws-resource*))

(pushnew 'find-ws-resource hunchensocket:*websocket-dispatch-table*)

;;; ---------------------------------------------------------------------
;;; message dispatch
;;; ---------------------------------------------------------------------
;;; Browser-to-Lisp messages are JSON objects with a :type field.
;;; Handlers are registered by type-string and are called with the
;;; resource, the client, and the parsed message alist.

(defparameter *message-handlers* (make-hash-table :test 'equal))

(defun register-message-handler (type handler)
  (setf (gethash type *message-handlers*) handler))

(defun unregister-message-handler (type)
  (remhash type *message-handlers*))

(defparameter *display-client-messages* nil)

(defun handle-client-message (resource client message)
  (when *display-client-messages*
    (format t "~&Received message from the browser client: ~%  ~S~%" message))
  (let* ((parsed (cl-json:decode-json-from-string message))
         (type (cdr (assoc :type parsed)))
         (handler (gethash type *message-handlers*)))
    (if handler
        (funcall handler resource client parsed)
        (format t "~&No handler for browser message type ~S: ~%  ~S~%" type message))))

(defmethod hunchensocket:text-message-received ((resource clio-ws-resource) client message)
  (handle-client-message resource client message))

(defmethod hunchensocket:client-connected ((resource clio-ws-resource) client)
  (declare (ignore resource client))
  (format t "~&Connected~%"))

(defmethod hunchensocket:client-disconnected ((resource clio-ws-resource) client)
  (declare (ignore resource client))
  (format t "~&Disconnected~%"))

;;; ---------------------------------------------------------------------
;;; sending messages to the browser
;;; ---------------------------------------------------------------------

(defun send-server-message (json)
  (let ((client (first (hunchensocket:clients *clio-ws-resource*))))
    (when client
      (hunchensocket:send-text-message client json))))

;;; ---------------------------------------------------------------------
;;; built-in ping / pong
;;; ---------------------------------------------------------------------
;;; Round-trip sanity check in both directions. When the browser sends
;;; a ping, Lisp replies with a pong. When the browser sends a pong (in
;;; reply to a Lisp-initiated ping), Lisp logs it.

(register-message-handler "ping"
                          (lambda (resource client parsed)
                            (declare (ignore resource client parsed))
                            (format t "~&Received ping from the browser~%")
                            (send-server-message (encode-pong))))

(register-message-handler "pong"
                          (lambda (resource client parsed)
                            (declare (ignore resource client parsed))
                            (format t "~&Received pong from the browser~%")))

(defun ping-browser ()
  (send-server-message (encode-ping)))

#+repl (ping-browser)

;;; ---------------------------------------------------------------------
;;; server operations
;;; ---------------------------------------------------------------------

(defun start-server (&key (show-lisp-errors t))
  (setf hunchentoot:*show-lisp-errors-p* show-lisp-errors)
  (if (and *clio-server* (listening? *clio-server*))
      (warn "The Clio server is already running")
      (progn (unless *clio-ws-resource*
               (setf *clio-ws-resource* (make-instance 'clio-ws-resource)))
             (setf *clio-server*
                   (make-instance 'clio-acceptor
                                  :port *clio-server-port*
                                  :document-root (http-document-root)))
             (hunchentoot:start *clio-server*)
             *clio-server*)))

#+repl (start-server)

(defun stop-server ()
  (when (listening? *clio-server*)
    (hunchentoot:stop *clio-server*)))

#+repl (stop-server)

(defmethod listening? ((server null)) nil)

(defmethod listening? ((server hunchentoot:acceptor))
  (and (hunchentoot::acceptor-listen-socket server) t))

#+repl (listening? *clio-server*)

(defun start-browser (&optional (url (format nil "http://localhost:~A/" *clio-server-port*)))
  #+(or win32 mswindows windows)
  (uiop:run-program (format nil "explorer ~S" url))
  #+(or macos darwin)
  (uiop:run-program (format nil "open ~S" url))
  #-(or win32 mswindows macos darwin windows)
  (uiop:run-program (format nil "xdg-open ~S" url)))
