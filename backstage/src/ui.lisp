;;;; ***********************************************************************
;;;;
;;;; Name:          ui.lisp
;;;; Project:       backstage: an Electron presentation server for Lisp
;;;; Purpose:       HTTP UI
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :backstage)

(hunchentoot:define-easy-handler (landing :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-output-to-string (out nil :prologue t)
    (:html
     (:head)
     (:body
      (:script :src "https://unpkg.com/htmx.org@2.0.4")
      (:h1 "backstage")
      (:div
       (:h4 (fmt "Running Hunchentoot on SBCL v~A" (lisp-implementation-version)))
       (:h5 "SBCL *features*:")
       (:p :font-size "8pt" (str cl:*features*)))
      ))
    (values)))
