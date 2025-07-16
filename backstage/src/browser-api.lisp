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

(defun send-to-browser (msg-plist)
  (let ((client (first (trivial-ws:clients backstage::*backstage-websocket-server*)))
        (json (cl-json:encode-json-plist-to-string msg-plist)))
    (trivial-ws:send client json)))

#+repl (send-to-browser '(:data "ping"))
