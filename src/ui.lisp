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
;;; favicon
;;; ---------------------------------------------------------------------
;;; Browsers fire an implicit GET /favicon.ico against the document
;;; root regardless of <link rel="icon"> declarations in the HTML
;;; head, so a request lands at /favicon.ico even when the page
;;; advertises the real location under /img/. This handler bridges the
;;; gap by serving the actual file from public/img/favicon.ico without
;;; putting anything back at the public root.

(hunchentoot:define-easy-handler (favicon :uri "/favicon.ico") ()
  (hunchentoot:handle-static-file
   (merge-pathnames "img/favicon.ico" (http-document-root))))


;;; ---------------------------------------------------------------------
;;; landing
;;; ---------------------------------------------------------------------

(hunchentoot:define-easy-handler (landing :uri "/") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:script :src "https://unpkg.com/htmx.org@2.0.4")
      (:script :src "https://unpkg.com/hyperscript.org@0.9.14")
      (:script :src "/js/clio-ws.js")
      (:script :src "https://cdn.jsdelivr.net/npm/umbrellajs")
      (:link :rel "icon" :type "image/x-icon" :href "/img/favicon.ico")
      (:link :rel "icon" :type "image/png" :sizes "16x16" :href "/img/favicon-16x16.png")
      (:link :rel "icon" :type "image/png" :sizes "32x32" :href "/img/favicon-32x32.png")
      (:link :rel "stylesheet" :href "https://unpkg.com/tachyons@4.12.0/css/tachyons.min.css"))
     (:body
      (:div :id "main-container"
            (:ul :id "eventlist"))
      (:footer :class "ph1 pv1 bt b--black-10 black-70"
               (:div :class "flex justify-between items-center f6 fw6"
                     (:div "Clio")
                     (:div ("SBCL v~A" (lisp-implementation-version)))))))))






