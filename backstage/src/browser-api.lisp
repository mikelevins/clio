;;;; ***********************************************************************
;;;;
;;;; Name:          browser-api.lisp
;;;; Project:       backstage: an Electron presentation server for Lisp
;;;; Purpose:       talking to the browser
;;;; Author:        mikel evins
;;;; Copyright:     2025 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :backstage)

;;; ---------------------------------------------------------------------
;;; encode messages
;;; ---------------------------------------------------------------------

(defun encode-ping ()
  (cl-json:encode-json-plist-to-string '(:type "ping")))

#+repl (encode-ping)

;;; ---------------------------------------------------------------------
;;; send to the browser
;;; ---------------------------------------------------------------------

(defun send-to-browser (json-msg)
  (let ((client (first (trivial-ws:clients backstage::*backstage-websocket-server*))))
    (trivial-ws:send client json-msg)))

#+repl (send-to-browser (encode-ping))


#+repl (backstage::start-server backstage::*backstage-http-server-port*)
#+repl (backstage::start-browser)
#+repl (backstage::stop-server)
#+repl (trivial-ws:clients backstage::*backstage-websocket-server*)
