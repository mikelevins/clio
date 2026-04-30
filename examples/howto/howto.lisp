;;;; ***********************************************************************
;;;;
;;;; Name:          howto.lisp
;;;; Project:       clio-example-howto
;;;; Purpose:       synthesis example: Lisp-minted button + custom message + HTMX
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio-example-howto)

;;; ---------------------------------------------------------------------
;;; landing page
;;; ---------------------------------------------------------------------
;;; Served at /howto so Clio's default / handler is left alone. The
;;; page is the synthesis demo: an announcement list (populated by a
;;; custom Lisp-pushed message type), a Lisp-minted button installed
;;; at runtime via INSTALL-BUTTON, and an HTMX-driven stats fragment.
;;; All three feed the same announcement model owned by Lisp.
;;;
;;; The two Clio script tags bracket the position where consumer
;;; registrations of inbound message handlers belong. clio-protocol.js
;;; defines REGISTERMESSAGEHANDLER and the dispatch table. The inline
;;; <script> between the two Clio tags registers this example's
;;; "announcement" handler before clio-ws.js opens the socket and
;;; messages start arriving. If that load order is broken, the first
;;; few announcements race the registration: clio-ws.js delivers them
;;; to DISPATCHCLIOMESSAGE, no handler is registered yet, and the
;;; built-in fall-through warns to the console with a load-order
;;; reminder.

(hunchentoot:define-easy-handler (howto-landing :uri "/howto") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:title "Clio HOWTO example")
      (:link :rel "stylesheet" :href "/css/howto.css")
      (:script :src "https://unpkg.com/htmx.org@2.0.4")
      (:script :src "/clio/js/clio-protocol.js")
      (:script
       (:raw
        "registerMessageHandler('announcement', function(envelope) {
    const ul = document.getElementById('announcements');
    const li = document.createElement('li');
    li.textContent = '[' + envelope.timestamp + '] ' + envelope.text;
    ul.appendChild(li);
});"))
      (:script :src "/clio/js/clio-ws.js"))
     (:body
      (:h1 "Clio HOWTO example")
      (:p "Three Clio mechanisms on one page: announcements pushed from "
          "Lisp over the WebSocket, a Lisp-minted button installed at "
          "runtime, and an HTMX fragment displaying stats. The HOWTO "
          "at the project root walks through how each piece is wired.")

      (:h2 "Announcements")
      (:p "Run "
          (:code "(howto:announce \"some text\")")
          " in the Lisp REPL to push an announcement to the list "
          "below. Each announcement is recorded Lisp-side and sent "
          "to the browser through a custom message type whose "
          "handler is registered in this page's "
          (:code "<head>") ".")
      (:ul :id "announcements")

      (:h2 "Lisp-minted button")
      (:p "After the page has loaded, run "
          (:code "(howto:install-button)")
          " in the Lisp REPL. A button labeled \"Announce my click\" "
          "will appear below; clicking it both records an "
          "announcement and pushes it to the page through the same "
          "channel that "
          (:code "(howto:announce ...)")
          " uses.")
      (:div :id "main-container")

      (:h2 "Stats")
      (:p "Click the button to fetch a stats fragment from "
          (:code "/howto/stats")
          ". The Lisp server reads its announcement list and "
          "returns an HTML fragment; HTMX swaps it into the "
          "stats panel below.")
      (:button :hx-get "/howto/stats"
               :hx-target "#stats"
               :hx-swap "innerHTML"
               "Show stats")
      (:div :id "stats")))))


;;; ---------------------------------------------------------------------
;;; stats fragment
;;; ---------------------------------------------------------------------
;;; Returns an HTML fragment for HTMX to swap into #stats. Reads
;;; *announcements* directly; the announcement model is owned by
;;; Lisp, so the HTMX request is just a synchronous read.

(hunchentoot:define-easy-handler (howto-stats :uri "/howto/stats") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (cond
      ((null *announcements*)
       (:span "No announcements yet."))
      (t
       (:span ("~A announcement~:P, last at ~A."
               (length *announcements*)
               (format-timestamp (car (first *announcements*)))))))))


;;; ---------------------------------------------------------------------
;;; announcement state and operations
;;; ---------------------------------------------------------------------
;;; *ANNOUNCEMENTS* holds the canonical announcement model: a list of
;;; (universal-time . text) cons cells, newest first. ANNOUNCE is the
;;; only writer; both INSTALL-BUTTON's click handler and the REPL
;;; route through it. The stats endpoint above reads the list. The
;;; browser is fed by ANNOUNCE pushing an "announcement" message
;;; whose handler (registered in the landing page's <head>) appends
;;; an <li> to the announcements list on the page.

(defparameter *announcements* '()
  "List of (universal-time . text) cons cells, newest first. Reset
on each call to START.")

(defun format-timestamp (universal-time)
  "Returns a zero-padded HH:MM:SS string for UNIVERSAL-TIME in local
time. Same format the htmx example uses for its greeting timestamps."
  (multiple-value-bind (sec min hour) (decode-universal-time universal-time)
    (format nil "~2,'0D:~2,'0D:~2,'0D" hour min sec)))

(defun announce (text)
  "Records an announcement in *ANNOUNCEMENTS* and pushes it to the
browser as a custom \"announcement\" message. The handler registered
in the landing page's <head> appends a list item to the
announcements list on the page.

If no browser is connected, CLIO::SEND-SERVER-MESSAGE silently drops
the outbound message; *ANNOUNCEMENTS* is updated either way, so the
stats endpoint will still see the announcement next time it's
queried. This matches the behavior the counters example documents."
  (let ((timestamp (get-universal-time)))
    (push (cons timestamp text) *announcements*)
    (clio::send-server-message
     (cl-json:encode-json-plist-to-string
      `(:type "announcement"
        :text ,text
        :timestamp ,(format-timestamp timestamp))))
    text))

#+repl (announce "first announcement")
#+repl (announce "second announcement")


;;; ---------------------------------------------------------------------
;;; Lisp-minted button
;;; ---------------------------------------------------------------------
;;; INSTALL-BUTTON mints a button on the page using ENCODE-CREATE-BUTTON
;;; with a FUNCTION-lane :ONCLICK closure. Click events round-trip:
;;; the browser sends an element-event message back to Lisp, Clio
;;; looks up the closure by element id, and calls it. The closure
;;; here just calls ANNOUNCE, so a button click produces the same
;;; effect as (howto:announce ...) at the REPL: state mutation plus
;;; an announcement message pushed to the page.

(defun install-button ()
  "Mints a button labeled 'Announce my click' on the page. Clicking
it records an announcement Lisp-side and pushes it to the page
through the same channel used by ANNOUNCE.

Requires that the browser has already connected to the Clio
WebSocket; if called before the browser is connected, the
create-button message is silently dropped by
CLIO::SEND-SERVER-MESSAGE."
  (clio::send-server-message
   (clio::encode-create-button
    "Announce my click"
    :onclick (lambda (element payload)
               (declare (ignore element payload))
               (announce "Lisp-minted button was clicked"))))
  (values))

#+repl (install-button)


;;; ---------------------------------------------------------------------
;;; entry points
;;; ---------------------------------------------------------------------
;;; The HOWTO documents the "drop-in" workflow: copy Clio's bundled
;;; public/ contents into examples/howto/public/clio/, and a single
;;; folder dispatcher at "/" serves both the example's own assets
;;; and Clio's. Same URL structure in dev and deploy; the only
;;; asymmetry is where public/ itself lives -- via ASDF in dev,
;;; relative to the running executable in deploy.
;;;
;;; START is the REPL entry point. CL-USER::MAIN, defined further
;;; down, is the dumped-image entry point and shares the same
;;; static-asset wiring through START.

(defun start ()
  "Starts the Clio server if not already running, then opens a
browser window on this example's landing page at /howto. Wires up a
single static-folder dispatcher serving the example's public/
subtree, which already contains a copy of Clio's bundled assets at
public/clio/.

Resets *ANNOUNCEMENTS* so a fresh REPL session starts with an empty
list. The browser-side announcements list is whatever's currently
in the DOM; reload the page to clear it."
  (setf *announcements* '())
  (clio:serve-static-folder
   "/"
   (if (clio:deployed-p)
       (clio:executable-relative-pathname "public/")
       (asdf:system-relative-pathname :clio-example-howto "public/")))
  (clio::start-server)
  (clio::start-browser
   (format nil "http://localhost:~A/howto" clio::*clio-server-port*)))

#+repl (start)


;;; ---------------------------------------------------------------------
;;; dumped-image entry point
;;; ---------------------------------------------------------------------
;;; CL-USER::MAIN is the entry point named in clio-example-howto.asd's
;;; :ENTRY-POINT, invoked by SAVE-LISP-AND-DIE when the dumped
;;; executable is run. It calls START to wire dispatchers, start the
;;; server, and open a browser, then blocks the main thread so the
;;; image keeps running. Hunchentoot's acceptor runs in its own
;;; thread, so the main thread has nothing else to do.
;;;
;;; START opens the user's default browser via UIOP:RUN-PROGRAM. On
;;; a graphical desktop that's the intended behavior; in headless
;;; environments START-BROWSER will signal an error which propagates
;;; out of MAIN and terminates the executable. A real deployment
;;; would either run on a desktop or skip the browser-open step --
;;; this tutorial executable assumes the desktop case.

(in-package :cl-user)

(defun main ()
  "Entry point for the dumped executable. Starts the server, opens
a browser, then enters the SBCL REPL on stdin/stdout so the
launching terminal becomes a Lisp prompt. Type (quit) to shut
down.

Re-enables the debugger before entering the REPL so an error at
the prompt drops into SBCL's debugger rather than triggering
ASDF program-op's fatal-condition handler, which would terminate
the image."
  (howto:start)
  (format t "~&Clio HOWTO example running.~%~
             This terminal is a Lisp REPL. Type (quit) to shut down.~%")
  #+sbcl
  (progn
    (sb-ext:enable-debugger)
    (sb-impl::toplevel-init)))
