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
      (:script :type "module"
               :src "https://cdn.jsdelivr.net/gh/starfederation/datastar@v1.0.0-beta.11/bundles/datastar.js")
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

      (:h2 "Datastar tests")
      (:input :data-bind "input")
      (:div :data-text "$input")

      (:input :type "checkbox" :data-bind "checkboxes.checkbox1" "Checkbox 1")
      (:input :type "checkbox" :data-bind "checkboxes.checkbox2" "Checkbox 2")
      (:input :type "checkbox" :data-bind "checkboxes.checkbox3" "Checkbox 3")
      (:button :data-on-click "@setAll('checkboxes.*', true)" "Check All")
      
      (:h2 "Server Info")
      (:div
       (:h4 (fmt "Running Hunchentoot on SBCL v~A" (lisp-implementation-version)))
       (:h5 "SBCL *features*:")
       (:p :font-size "8pt" (str cl:*features*)))
      ))
    (values)))
