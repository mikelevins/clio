;;;; ***********************************************************************
;;;;
;;;; Name:          browser-api.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       talking to the browser
;;;; Author:        mikel evins
;;;; Copyright:     2025 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

;;; ---------------------------------------------------------------------
;;; element ids
;;; ---------------------------------------------------------------------
;;; Element id minting and the element registry now live in
;;; registry.lisp. Message-encoding functions here create and register
;;; clio-element instances through MAKE-ELEMENT, then emit JSON
;;; envelopes carrying :id so the browser can route messages to the
;;; corresponding registered wrapper.

;;; ---------------------------------------------------------------------
;;; encode messages
;;; ---------------------------------------------------------------------

(defun encode-ping ()
  (cl-json:encode-json-plist-to-string '(:type "ping")))

#+repl (encode-ping)

(defun encode-pong ()
  (cl-json:encode-json-plist-to-string '(:type "pong")))

#+repl (encode-pong)

(defun encode-reload ()
  (cl-json:encode-json-plist-to-string '(:type "reload")))

#+repl (encode-reload)

(defun encode-create-button (text &key
                                    (id (make-element-id))
                                    (onclick nil))
  "Encodes a create-button message for the browser.

TEXT is the visible button label. ID is a KSUID string; a fresh one is
minted if not supplied. ONCLICK selects one of four click-handler
lanes, dispatched by type:

  NIL          -- no click behavior. The envelope carries no :onclick;
                  the browser wires no onclick handler. Clicks are
                  inert.

  STRING       -- literal JavaScript source. Ships in the envelope as
                  :onclick. The browser evals it and assigns the result
                  to btn.onclick. The escape hatch; preserves the
                  pre-registry behavior for cases where a typed
                  vocabulary would be too slow to reach for.

  CONS         -- a Parenscript form. Compiled to JS at encode time via
                  PS:PS*, then sent the same way as a literal string.
                  Browser behavior is identical to the STRING lane;
                  authoring moves into Lisp.

  FUNCTION     -- a Lisp function of two arguments (element, payload).
                  Stored on the element's :click slot via
                  REGISTER-EVENT-HANDLER. The envelope carries
                  :onclick t as a sentinel; the browser-side relay
                  sends an element-event message back to Lisp on
                  click, and the element-event dispatcher funcalls
                  this function.

Returns the JSON string to ship over the websocket."
  ;; TODO (next session that adds a non-button element): lift the
  ;; ETYPECASE below and the conditional plist building into a shared
  ;; helper, probably named ENCODE-EVENT-HANDLER. The helper should take
  ;; (element event-name handler), register on the element when HANDLER
  ;; is a function, and return either the value to put in the envelope
  ;; under EVENT-NAME or a sentinel meaning "omit this key." Each
  ;; ENCODE-CREATE-* then builds its envelope by consulting the helper
  ;; per event attribute (:onclick, :onmouseover, :onkeydown, ...) and
  ;; omitting the corresponding keys when resolution returned the
  ;; sentinel. Paired with the JS-side RESOLVEEVENTHANDLER TODO in
  ;; clio-ws.js.
  (let ((element (make-element "button" :id id)))
    (etypecase onclick
      (null
       (cl-json:encode-json-plist-to-string
        `(:type "create-element"
          :element-type "button"
          :id ,id
          :text ,text)))
      (string
       (cl-json:encode-json-plist-to-string
        `(:type "create-element"
          :element-type "button"
          :id ,id
          :text ,text
          :onclick ,onclick)))
      (cons
       (cl-json:encode-json-plist-to-string
        `(:type "create-element"
          :element-type "button"
          :id ,id
          :text ,text
          :onclick ,(ps:ps* onclick))))
      (function
       (register-event-handler element :click onclick)
       (cl-json:encode-json-plist-to-string
        `(:type "create-element"
          :element-type "button"
          :id ,id
          :text ,text
          :onclick t))))))

#+repl (encode-create-button "Hello")
#+repl (encode-create-button "JS" :onclick "function(){alert('hi');}")
#+repl (encode-create-button "PS" :onclick '(lambda () (alert "hi from parenscript")))
#+repl (encode-create-button "Lisp" :onclick (lambda (elt payload)
                                               (declare (ignore elt payload))
                                               (format t "~&clicked~%")))

;;; ---------------------------------------------------------------------
;;; inbound element events
;;; ---------------------------------------------------------------------
;;; The browser sends an element-event message when a user interacts
;;; with an element whose handler lives in Lisp (the FUNCTION lane of
;;; ENCODE-CREATE-BUTTON and its future siblings). The envelope shape
;;; is:
;;;
;;;   {"type": "element-event",
;;;    "event": "click",        -- or mouseover, keydown, ...
;;;    "id": "<ksuid>",
;;;    ...event-specific fields, e.g. x, y for canvas clicks...}
;;;
;;; Dispatch is two-step: the "element-event" type handler below looks
;;; the element up by :id in the element registry, retrieves the
;;; handler function registered under the event name, and funcalls it
;;; with the element and the full message payload.

(defun as-message-payload (parsed-alist)
  "Converts a CL-JSON-decoded alist to a keyword-keyed plist.
Signals an error if any key appears more than once -- Clio's
wire-format invariant is that envelopes have unique keys. Both ends of
the wire uphold this by construction; this check guards against drift.
See the wire-format invariants block at the top of registry.lisp."
  (let ((plist '())
        (seen '()))
    (dolist (pair parsed-alist)
      (let* ((raw-key (car pair))
             (key (intern (symbol-name raw-key) :keyword)))
        (when (member key seen)
          (error "Duplicate key ~S in message payload: ~S" key parsed-alist))
        (push key seen)
        (setf plist (append plist (list key (cdr pair))))))
    plist))

(register-message-handler "element-event"
  (lambda (resource client parsed)
    (declare (ignore resource client))
    (let* ((payload (as-message-payload parsed))
           (id (getf payload :id))
           (event-string (getf payload :event))
           (event-name (intern (string-upcase event-string) :keyword))
           (element (lookup-element id))
           (handler (and element (lookup-event-handler element event-name))))
      (cond
        ((null element)
         (format t "~&element-event for unknown element id ~A~%" id))
        ((null handler)
         (format t "~&No ~A handler for element ~A~%" event-string id))
        (t
         (funcall handler element payload))))))


#+repl (asdf:load-system :clio)
#+repl (clio::start-server)
#+repl (clio::start-browser)
#+repl (clio::stop-server)
#+repl (hunchensocket:clients clio::*clio-ws-resource*)
