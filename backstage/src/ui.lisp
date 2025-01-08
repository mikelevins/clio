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
     (:head
      (:script :src "https://unpkg.com/htmx.org@2.0.4")
      (:script :src "https://cdn.jsdelivr.net/npm/vega@5")
      (:script :src "https://cdn.jsdelivr.net/npm/vega-lite@5")
      (:script :src "https://cdn.jsdelivr.net/npm/vega-embed@5"))
     (:body
      (:h1 "backstage")
      (:h2 "Vega Example")
      (:div :id "vis")
      (:script :type "text/javascript"
               "var spec = \"https://raw.githubusercontent.com/vega/vega/master/docs/examples/bar-chart.vg.json\";
  vegaEmbed('#vis', spec).then(function(result) {
    // Access the Vega view instance (https://vega.github.io/vega/docs/api/view/) as result.view
  }).catch(console.error);"
               )
      (:h2 "Server Info")
      (:div
       (:h4 (fmt "Running Hunchentoot on SBCL v~A" (lisp-implementation-version)))
       (:h5 "SBCL *features*:")
       (:p :font-size "8pt" (str cl:*features*)))
      ))
    (values)))
