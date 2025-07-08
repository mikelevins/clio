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
     (:div :id "main-container")
     (:footer :class "ph1 pv1 bt b--black-10 black-70"
              (:div :class "flex justify-between items-center f6 fw6"
                    (:div "Clio")
                    (:a :href "/vegalite-test" (:h3 "VegaLite Test"))
                    (:div (fmt "SBCL v~A" (lisp-implementation-version))))))
    (values)))


;;; ---------------------------------------------------------------------
;;; VegaLite test
;;; ---------------------------------------------------------------------

(hunchentoot:define-easy-handler (vegalite-test :uri "/vegalite-test") ()
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
            (:ul (:li "airport-connections")
                 (:li "annual-precipitation")
                 (:li "annual-temperature")
                 (:li "arc-diagram")
                 (:li "area-chart")
                 (:li "bar-chart")
                 (:li "bar-line-toggle")
                 (:li "barley-trellis-plot")
                 (:li "beeswarm-plot")
                 (:li "binned-scatter-plot")
                 (:li "box-plot")
                 (:li "brushing-scatter-plots")
                 (:li "budget-forecasts")
                 (:li "calendar-view")
                 (:li "circle-packing")
                 (:li "clock")
                 (:li "connected-scatter-plot")
                 (:li "contour-plot")
                 (:li "county-unemployment")
                 (:li "crossfilter-flights")
                 (:li "density-heatmaps")
                 (:li "distortion-comparison")
                 (:li "donut-chart-labelled")
                 (:li "donut-chart")
                 (:li "dorling-cartogram")
                 (:li "dot-plot")
                 (:li "earthquakes-globe")
                 (:li "earthquakes")
                 (:li "edge-bundling")
                 (:li "error-bars")
                 (:li "falkensee-population")
                 (:li "flight-passengers")
                 (:li "force-directed-layout")
                 (:li "global-development")
                 (:li "grouped-bar-chart")
                 (:li "heatmap")
                 (:li "histogram-null-values")
                 (:li "histogram")
                 (:li "horizon-graph")
                 (:li "hypothetical-outcome-plots")
                 (:li "interactive-legend")
                 (:li "job-voyager")
                 (:li "labeled-scatter-plot")
                 (:li "line-chart")
                 (:li "loess-regression")
                 (:li "map-with-tooltip")
                 (:li "nested-bar-chart")
                 (:li "overview-plus-detail")
                 (:li "packed-bubble-chart")
                 (:li "pacman")
                 (:li "parallel-coordinates")
                 (:li "pi-monte-carlo")
                 (:li "pie-chart")
                 (:li "platformer")
                 (:li "population-pyramid")
                 (:li "probability-density")
                 (:li "projections")
                 (:li "quantile-dot-plot")
                 (:li "quantile-quantile-plot")
                 (:li "radar-chart")
                 (:li "radial-plot")
                 (:li "radial-tree-layout")
                 (:li "regression")
                 (:li "reorderable-matrix")
                 (:li "scatter-plot-null-values")
                 (:li "scatter-plot")
                 (:li "serpentine-timeline")
                 (:li "stacked-area-chart")
                 (:li "stacked-bar-chart")
                 (:li "stock-index-chart")
                 (:li "sunburst")
                 (:li "table-scrollbar")
                 (:li "time-units")
                 (:li "timelines")
                 (:li "top-k-plot-with-others")
                 (:li "top-k-plot")
                 (:li "tree-layout")
                 (:li "treemap")
                 (:li "u-district-cuisine")
                 (:li "violin-plot")
                 (:li "volcano-contours")
                 (:li "warming-stripes")
                 (:li "watch")
                 (:li "weekly-temperature")
                 (:li "wheat-and-wages")
                 (:li "wheat-plot")
                 (:li "wind-vectors")
                 (:li "word-cloud")
                 (:li "world-map")
                 (:li "zoomable-binned-plot")
                 (:li "zoomable-circle-packing")
                 (:li "zoomable-scatter-plot")
                 (:li "zoomable-world-map")))
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

