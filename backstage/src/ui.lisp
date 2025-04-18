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
      (:script :src "https://unpkg.com/hyperscript.org@0.9.14")
      (:script :src "https://cdn.jsdelivr.net/npm/vega@5")
      (:script :src "https://cdn.jsdelivr.net/npm/vega-lite@5")
      (:script :src "https://cdn.jsdelivr.net/npm/vega-embed@5")
      (:script :type "text/javascript"
"function showSpec(){
  let specname = document.getElementById('specID');
  let spec = 'https://raw.githubusercontent.com/vega/vega/master/docs/examples/'+specname.value+'.vg.json'
  vegaEmbed('#vis', spec);
}"))
     (:body
      (:h1 "backstage")
      (:h2 "Vega Examples")
      (:div (:p "Taken from https://github.com/vega/vega/tree/main/docs/examples")
            (:p "Try any name from that repo that ends in '.vg.json'"))
      (:div "For example:"
            (:ul (:li "bar-chart")
                 (:li "annual-precipitation")
                 (:li "area-chart")
                 (:li "clock")))
      (:div :id "vis")
      (:div (:input :id "specID" :type "text" :value "bar-chart")
            (:button :onclick "showSpec()" "Show"))
      (:h2 "Server Info")
      (:div
       (:h4 (fmt "Running Hunchentoot on SBCL v~A" (lisp-implementation-version)))
       (:h5 "SBCL *features*:")
       (:p :font-size "8pt" (str cl:*features*)))
      ))
    (values)))
