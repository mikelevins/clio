;;;; ***********************************************************************
;;;;
;;;; Name:          htmx.lisp
;;;; Project:       clio-example-htmx
;;;; Purpose:       request/response greeting and live-filter input via HTMX
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio-example-htmx)

;;; ---------------------------------------------------------------------
;;; sample data
;;; ---------------------------------------------------------------------
;;; A fruit list chosen for demonstrative filtering. Dense letter
;;; overlap means the displayed subset shifts at most typed
;;; characters, not just the first or the last. The specific items
;;; carry no meaning beyond being easy to read and remember.

(defparameter *fruits*
  '("apple" "apricot" "avocado" "banana" "blackberry" "blueberry"
    "cherry" "cranberry" "date" "fig" "grape" "grapefruit" "guava"
    "kiwi" "lemon" "lime" "mango" "melon" "nectarine" "orange"
    "papaya" "peach" "pear" "persimmon" "pineapple" "plum"
    "pomegranate" "quince" "raspberry" "strawberry" "tangerine"
    "watermelon"))

(defun current-time-string ()
  "Returns a zero-padded HH:MM:SS string for the current local time."
  (multiple-value-bind (sec min hour) (get-decoded-time)
    (format nil "~2,'0D:~2,'0D:~2,'0D" hour min sec)))

;;; ---------------------------------------------------------------------
;;; landing page
;;; ---------------------------------------------------------------------
;;; Served at /htmx. Two independent demos on one page: a
;;; request/response greeting triggered by a button, and a live
;;; filter over the fruit list. Both are pure HTMX: HTTP GETs to
;;; fragment endpoints whose responses replace the innerHTML of a
;;; target element. No WebSocket, no element registry, no Clio
;;; message types are involved.

(hunchentoot:define-easy-handler (htmx-landing :uri "/htmx") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:title "Clio HTMX example")
      (:script :src "https://unpkg.com/htmx.org@2.0.4"))
     (:body
      (:h1 "Clio HTMX example")

      (:h2 "Request / response greeting")
      (:p "Clicking the button below sends an HTTP GET to "
          (:code "/htmx/greet") ". The Clio server returns a small "
          "HTML fragment including the current time, and HTMX "
          "swaps it into the target div.")
      (:button :hx-get "/htmx/greet"
               :hx-target "#greeting"
               :hx-swap "innerHTML"
               "Greet me")
      (:div :id "greeting")

      (:h2 "Live filter")
      (:p "Type in the input below to filter the fruit list. Each "
          "keystroke, after a 200ms idle debounce, sends an HTTP "
          "GET to "
          (:code "/htmx/filter")
          " with the current input value. The server returns an "
          "HTML fragment of matching items, which HTMX swaps into "
          "the list below.")
      (:input :type "text"
              :name "q"
              :placeholder "type to filter..."
              :hx-get "/htmx/filter"
              :hx-trigger "keyup changed delay:200ms"
              :hx-target "#fruit-list"
              :hx-swap "innerHTML")
      (:ul :id "fruit-list"
           (dolist (fruit *fruits*)
             (:li fruit)))))))

;;; ---------------------------------------------------------------------
;;; fragment endpoints
;;; ---------------------------------------------------------------------
;;; Each endpoint returns an HTML fragment, not a full document.
;;; Spinneret's WITH-HTML-STRING is happy to produce fragments; the
;;; response has text/html content type, and HTMX handles the swap.

(hunchentoot:define-easy-handler (htmx-greet :uri "/htmx/greet") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:span ("Hello from Lisp at ~A!" (current-time-string)))))

(hunchentoot:define-easy-handler (htmx-filter :uri "/htmx/filter") (q)
  (setf (hunchentoot:content-type*) "text/html")
  (let ((query (or q "")))
    (with-html-string
      (dolist (fruit *fruits*)
        (when (search query fruit :test #'char-equal)
          (:li fruit))))))

;;; ---------------------------------------------------------------------
;;; entry point
;;; ---------------------------------------------------------------------

(defun start ()
  "Starts the Clio server if not already running, then opens a
browser window on this example's landing page at /htmx."
  (clio::start-server)
  (clio::start-browser
   (format nil "http://localhost:~A/htmx" clio::*clio-server-port*)))

#+repl (start)
