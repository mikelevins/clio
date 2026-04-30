;;;; ***********************************************************************
;;;;
;;;; Name:          hello.lisp
;;;; Project:       clio-example-hello
;;;; Purpose:       simplest Clio example: input, button, checkbox, round-trip
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package #:clio-example-hello)

;;; ---------------------------------------------------------------------
;;; landing page
;;; ---------------------------------------------------------------------
;;; Served at /hello so that Clio's own landing handler at / is left
;;; alone. The page is plain HTML5: a text input, a "Hello" button,
;;; and a "Send to Lisp?" checkbox. Behavior is wired at the bottom
;;; of <body> by a Parenscript block that attaches a click listener
;;; to the button. Click behavior:
;;;
;;;   - always: alert "Hello!", or "Hello, NAME!" if the input has
;;;     text.
;;;   - additionally, if the checkbox is checked: send the same
;;;     greeting string to Lisp over the websocket as a message of
;;;     type "hello-greeting"; the Lisp-side handler defined below
;;;     prints the greeting to *standard-output*.

(hunchentoot:define-easy-handler (hello-landing :uri "/hello") ()
  (setf (hunchentoot:content-type*) "text/html")
  (with-html-string
    (:doctype)
    (:html
     (:head
      (:title "Clio hello example")
      (:script :src "/clio/js/clio-protocol.js")
      (:script :src "/clio/js/clio-ws.js"))
     (:body
      (:h1 "Clio hello example")
      (:p (:input :id "hello-name" :type "text" :placeholder "Your name"))
      (:p (:button :id "hello-button" "Hello"))
      (:p (:label
           (:input :id "hello-send" :type "checkbox")
           " Send to Lisp?"))
      (:script
       (:raw
        (ps (let ((button (chain document (get-element-by-id "hello-button")))
                  (name-input (chain document (get-element-by-id "hello-name")))
                  (send-checkbox (chain document (get-element-by-id "hello-send"))))
              (chain button
                     (add-event-listener
                      "click"
                      (lambda ()
                        (let* ((name (chain name-input value))
                               (greeting (if (> (chain name length) 0)
                                             (+ "Hello, " name "!")
                                             "Hello!")))
                          (alert greeting)
                          (when (chain send-checkbox checked)
                            (send-object
                             (create :type "hello-greeting"
                                     :text greeting)))))))))))))))

;;; ---------------------------------------------------------------------
;;; inbound message handler
;;; ---------------------------------------------------------------------
;;; The "hello-greeting" message type is this example's own. The
;;; initializer below registers the handler with Clio's built-in
;;; message-handler table via the standard
;;; REGISTER-HANDLER-INITIALIZER path, so the registration survives
;;; server restarts and reloads of Clio's server.lisp.

(defun handle-hello-greeting (resource client parsed)
  (declare (ignore resource client))
  (format t "~&~A~%" (cdr (assoc :text parsed))))

(defun initialize-hello-example-message-handlers ()
  "Registers this example's message handlers. Called by
CLIO:REGISTER-HANDLER-INITIALIZER on load, and again by
CLIO::INITIALIZE-HANDLERS whenever the handler table is rebuilt."
  (clio:register-message-handler "hello-greeting" 'handle-hello-greeting))

(clio:register-handler-initializer 'initialize-hello-example-message-handlers)

;;; ---------------------------------------------------------------------
;;; entry point
;;; ---------------------------------------------------------------------
;;; (clio-example-hello:start) starts the Clio server (if it is not
;;; already running) and opens a browser window on this example's
;;; landing page at /hello. If the server is already running, the
;;; underlying CLIO:START-SERVER signals a harmless warning and
;;; returns; the browser still opens.

(defun start ()
  "Starts the Clio server if not already running, then opens a
browser window on this example's landing page at /hello."
  (clio:serve-static-folder "/clio/" (clio:asset-directory))
  (clio:start-server)
  (clio:start-browser
   (format nil "http://localhost:~A/hello" clio:*clio-server-port*)))

#+repl (start)
