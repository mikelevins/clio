;;;; ***********************************************************************
;;;;
;;;; Name:          ui.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       HTTP UI
;;;; Author:        mikel evins
;;;; Copyright:     2024 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)


;;; ---------------------------------------------------------------------
;;; landing
;;; ---------------------------------------------------------------------

(hunchentoot:define-easy-handler (landing :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-output-to-string (out nil :prologue t)
    (:html
     (:head
      (:script :src "https://unpkg.com/htmx.org@2.0.4")
      (:script :src "https://unpkg.com/hyperscript.org@0.9.14")
      (:script :src "https://cdn.jsdelivr.net/npm/umbrellajs")
      (:link :rel "stylesheet" :href "https://unpkg.com/tachyons@4.12.0/css/tachyons.min.css")))
    (:body
     (:div :id "main-container"
           (:ul :id "eventlist"))
     (:footer :class "ph1 pv1 bt b--black-10 black-70"
              (:div :class "flex justify-between items-center f6 fw6"
                    (:div "Clio")
                    (:div (fmt "SBCL v~A" (lisp-implementation-version))))))
    (values)))






