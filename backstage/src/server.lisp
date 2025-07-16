;;;; ***********************************************************************
;;;;
;;;; Name:          ui.lisp
;;;; Project:       backstage: an Electron presentation server for Lisp
;;;; Purpose:       HTTP UI
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :hunchentoot)

(defmethod start-listening ((acceptor acceptor))
  (when (acceptor-listen-socket acceptor)
    (hunchentoot-error "acceptor ~A is already listening" acceptor))
  (setf (acceptor-listen-socket acceptor)
        (usocket:socket-listen (or (acceptor-address acceptor)
                                   usocket:*wildcard-host*)
                               (acceptor-port acceptor)
                               :reuseaddress t
                               :reuse-address t
                               :backlog (acceptor-listen-backlog acceptor)
                               :element-type '(unsigned-byte 8)))
  (values))

(in-package :backstage)

(defun start-server (&optional (port *backstage-http-server-port*))
  (setf cl-who:*attribute-quote-char* #\")
  (setf *backstage-http-server*
        (make-instance 'hunchentoot:easy-acceptor
                       :port port
                       :document-root (http-document-root)))
  (setf *backstage-websocket-server*
        (trivial-ws:make-server
         :on-connect #'(lambda (server)(format t "Connected~%"))
         :on-disconnect #'(lambda (server)(format t "Disconnected~%"))
         :on-message 'handle-ws-message))
  (hunchentoot:start *backstage-http-server*)
  (setf *backstage-websocket-handler*
        (trivial-ws:start *backstage-websocket-server*
                          *backstage-websocket-port*)))

(defun stop-server ()
  (when (hunchentoot::acceptor-listen-socket *backstage-http-server*)
    (hunchentoot:stop *backstage-http-server*))
  (when (hunchentoot::acceptor-listen-socket *backstage-websocket-handler*)
    (trivial-ws:stop *backstage-websocket-handler*)))

(defmethod listening? ((server null)) nil)

(defmethod listening? ((server hunchentoot:acceptor))
  (and (hunchentoot::acceptor-listen-socket server) t))

(defmethod listening? ((server trivial-ws:server))
  (and (hunchentoot::acceptor-listen-socket server) t))

(defun handle-ws-message (server message)
  (let ((msg (read-from-string message)))
    (cond ((equal msg '(:ping))(format t "handle-ws-message: Received ping: (~S): ~A~%" server message))
          (t (format t "handle-ws-message: Received unrecognized message: (~S): ~A~%" server message)))))

(defun start-browser (&optional (url (format nil "http://localhost:~A/" *backstage-http-server-port*)))
  #+(or win32 mswindows windows)
  (uiop:run-program (format nil "explorer ~S" url))
  #+(or macos darwin)
  (uiop:run-program (format nil "open ~S" url))
  #-(or win32 mswindows macos darwin windows)
  (uiop:run-program (format nil "xdg-open ~S" url)))

#+test (start-server *backstage-http-server-port*)
#+test (stop-server)
