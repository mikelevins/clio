;;;; ***********************************************************************
;;;;
;;;; Name:          browser-api.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       talking to the browser
;;;; Author:        mikel evins
;;;; Copyright:     2025 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

;;; ---------------------------------------------------------------------
;;; element ids
;;; ---------------------------------------------------------------------

(defparameter *element-counter* 0)

(defun next-element-id ()
  (let ((n (incf *element-counter*)))
    (format nil "elt~D" n)))

#+repl (next-element-id)

;;; ---------------------------------------------------------------------
;;; encode messages
;;; ---------------------------------------------------------------------

(defun encode-ping ()
  (cl-json:encode-json-plist-to-string '(:type "ping")))

#+repl (encode-ping)

(defun encode-pong ()
  (cl-json:encode-json-plist-to-string '(:type "pong")))

#+repl (encode-pong)

(defun encode-reload ()
  (cl-json:encode-json-plist-to-string '(:type "reload")))

#+repl (encode-reload)

(defun encode-create-button (text &key
                                    (id (next-element-id))
                                    (onclick nil))
  (cl-json:encode-json-plist-to-string `(:type "create-element"
                                         :element-type "button"
                                         :id ,id
                                         :text ,text
                                         :onclick ,onclick)))

#+repl (encode-create-button "Hello")


#+repl (asdf:load-system :clio)
#+repl (clio::start-server)
#+repl (clio::start-browser)
#+repl (clio::stop-server)
#+repl (hunchensocket:clients clio::*clio-ws-resource*)
