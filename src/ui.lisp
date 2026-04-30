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
;;; advertises the real location under /clio/img/. This handler
;;; bridges the gap by serving the actual file out of Clio's bundled
;;; asset directory. A consumer that wants its own favicon can
;;; redefine an easy-handler at the same URI; last-defined wins.

(hunchentoot:define-easy-handler (favicon :uri "/favicon.ico") ()
  (hunchentoot:handle-static-file
   (merge-pathnames "img/favicon.ico" (asset-directory))))


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
      (:script :src "/clio/js/clio-protocol.js")
      (:script :src "/clio/js/clio-ws.js")
      (:script :src "https://cdn.jsdelivr.net/npm/umbrellajs")
      (:link :rel "icon" :type "image/x-icon" :href "/clio/img/favicon.ico")
      (:link :rel "icon" :type "image/png" :sizes "16x16" :href "/clio/img/favicon-16x16.png")
      (:link :rel "icon" :type "image/png" :sizes "32x32" :href "/clio/img/favicon-32x32.png")
      (:link :rel "stylesheet" :href "https://unpkg.com/tachyons@4.12.0/css/tachyons.min.css"))
     (:body
      (:div :id "main-container"
            (:ul :id "eventlist"))
      (:footer :class "ph1 pv1 bt b--black-10 black-70"
               (:div :class "flex justify-between items-center f6 fw6"
                     (:div "Clio")
                     (:div ("SBCL v~A" (lisp-implementation-version)))))))))






