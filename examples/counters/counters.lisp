;;;; ***********************************************************************
;;;;
;;;; Name:          counters.lisp
;;;; Project:       clio-example-counters
;;;; Purpose:       three buttons, per-button Lisp-side click handlers
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio-example-counters)

;;; ---------------------------------------------------------------------
;;; landing page
;;; ---------------------------------------------------------------------
;;; Served at /counters so Clio's default / handler is left alone.
;;; The page is almost empty on arrival: a #main-container div (where
;;; Clio's handleCreateButton appends new buttons) and instruction
;;; text telling the user to run INSTALL-BUTTONS at the REPL. Every
;;; element on this page is dynamic; nothing is wired at page-render
;;; time.

(hunchentoot:define-easy-handler (counters-landing :uri "/counters") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:title "Clio counters example")
      (:script :src "/clio/js/clio-protocol.js")
      (:script :src "/clio/js/clio-ws.js"))
     (:body
      (:h1 "Clio counters example")
      (:p "After this page has loaded and the WebSocket has connected, run "
          (:code "(clio-example-counters:install-buttons)")
          " in the Lisp REPL. Three buttons labeled A, B, and C will appear below. "
          "Clicking each button increments its own counter and prints the running tallies "
          "to the Lisp REPL. Per-button routing is handled by Clio's element registry.")
      (:div :id "main-container")))))

;;; ---------------------------------------------------------------------
;;; per-button state and handlers
;;; ---------------------------------------------------------------------
;;; *counters* holds one (label . count) cons cell per installed
;;; button, in the order they were minted. The click handler for each
;;; button closes over its own cell, so per-button dispatch is carried
;;; by Clio's element registry (FUNCTION lane of encode-create-button)
;;; and per-button state is carried by Lisp closures. Three buttons
;;; all emit element-event messages with type "element-event" and
;;; event "click"; what distinguishes them is element id, and the
;;; registry is what turns that id back into the right closure.

(defparameter *counters* '()
  "List of (label . count) cons cells, one per installed counter button,
in the order they were installed. INSTALL-BUTTONS resets this.")

(defun format-all-counts ()
  "Formats a single line like 'A: 3, B: 1, C: 2' to *standard-output*,
covering every currently-installed counter in install order."
  (format t "~&~{~A: ~A~^, ~}~%"
          (loop for (label . count) in (reverse *counters*)
                collect label collect count)))

(defun make-counter-button (label)
  "Mints one counter button in the browser and registers a
per-button Lisp-side click handler that closes over its own counter
cell."
  (let ((counter (cons label 0)))
    (push counter *counters*)
    (clio::send-server-message
     (clio::encode-create-button
      label
      :onclick (lambda (element payload)
                 (declare (ignore element payload))
                 (incf (cdr counter))
                 (format-all-counts))))
    counter))

;;; ---------------------------------------------------------------------
;;; entry points
;;; ---------------------------------------------------------------------

(defun start ()
  "Starts the Clio server if not already running, then opens a
browser window on this example's landing page at /counters. Once the
page has loaded, call INSTALL-BUTTONS to mint the three counter
buttons."
  (clio:serve-static-folder "/clio/" (clio:asset-directory))
  (clio::start-server)
  (clio::start-browser
   (format nil "http://localhost:~A/counters" clio::*clio-server-port*)))

(defun install-buttons ()
  "Mints three counter buttons (A, B, C) in the browser. Requires
that the browser has already connected to the Clio WebSocket; if
called before the browser is connected, the create-button messages
are silently dropped by CLIO::SEND-SERVER-MESSAGE (see NOTES.md).
Resets *counters* on each call, so repeated calls start fresh
Lisp-side -- but the browser-side accumulates DOM buttons from prior
calls unless the page is reloaded."
  (setf *counters* '())
  (dolist (label '("A" "B" "C"))
    (make-counter-button label))
  (values))

#+repl (start)
#+repl (install-buttons)
