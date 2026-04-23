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

;;; ---------------------------------------------------------------------
;;; event-handler encoding helper
;;; ---------------------------------------------------------------------
;;; ENCODE-EVENT-HANDLER encapsulates the four-lane dispatch shared by
;;; every ENCODE-CREATE-* function that accepts event attributes. Each
;;; caller invokes it once per event attribute it supports, passing
;;; the element, the event keyword (:click, :change, :mouseover, ...),
;;; and the user-supplied handler.
;;;
;;; The return value is either the value to place in the envelope
;;; under the event attribute's key, or *OMIT-EVENT-KEY* meaning "do
;;; not include this key." Callers build the final envelope plist
;;; with MAKE-ENVELOPE-PLIST, which filters out keys whose value is
;;; the omit sentinel.
;;;
;;; The four lanes, dispatched by HANDLER's type:
;;;
;;;   NIL      -- no handler. Returns *OMIT-EVENT-KEY*; the caller
;;;               leaves the event attribute out of the envelope and
;;;               the browser wires nothing. Interactions are inert.
;;;
;;;   STRING   -- literal JavaScript source. Returned unchanged for
;;;               inclusion in the envelope. The browser evals it and
;;;               assigns the result to the appropriate DOM handler
;;;               slot. The escape hatch for cases where a typed
;;;               vocabulary would be too slow to reach for.
;;;
;;;   CONS     -- a Parenscript form. Compiled to JS at encode time
;;;               via PS:PS* and returned as a string. Browser
;;;               behavior is identical to the STRING lane.
;;;
;;;   FUNCTION -- a Lisp function of two arguments (element, payload).
;;;               Registered on ELEMENT under EVENT-NAME via
;;;               REGISTER-EVENT-HANDLER. Returns T as a sentinel;
;;;               the browser-side relay sends an element-event
;;;               message back to Lisp and the element-event
;;;               dispatcher funcalls the registered function.
;;;
;;; Paired with RESOLVEEVENTHANDLER on the JS side in clio-ws.js.

(defparameter *omit-event-key* (make-symbol "OMIT")
  "Sentinel returned by ENCODE-EVENT-HANDLER meaning 'omit this key
from the envelope.' An uninterned symbol so it cannot collide with
any legitimate envelope value.")

(defun encode-event-handler (element event-name handler)
  "Resolves HANDLER to the envelope value for EVENT-NAME's key.
See the commentary block above for the four-lane dispatch rules."
  (etypecase handler
    (null     *omit-event-key*)
    (string   handler)
    (cons     (ps:ps* handler))
    (function
     (register-event-handler element event-name handler)
     t)))

(defun make-envelope-plist (base &rest key-value-pairs)
  "Returns a plist built by appending KEY-VALUE-PAIRS to BASE, with
any pair whose value is *OMIT-EVENT-KEY* filtered out. BASE is
assumed already sanitized. Keyword/value args are supplied as
alternating arguments, e.g.

  (make-envelope-plist '(:type \"x\") :onclick v1 :onchange v2)"
  (let ((result (copy-list base)))
    (loop for (k v) on key-value-pairs by #'cddr
          unless (eq v *omit-event-key*)
            do (setf result (append result (list k v))))
    result))

(defun encode-create-button (text &key
                                    (id (make-element-id))
                                    (onclick nil))
  "Encodes a create-button message for the browser.

TEXT is the visible button label. ID is a KSUID string; a fresh one
is minted if not supplied. ONCLICK selects one of four click-handler
lanes; see the commentary above ENCODE-EVENT-HANDLER for the
dispatch rules.

Returns the JSON string to ship over the websocket."
  (let* ((element (make-element "button" :id id))
         (onclick-value (encode-event-handler element :click onclick)))
    (cl-json:encode-json-plist-to-string
     (make-envelope-plist
      `(:type "create-element"
        :element-type "button"
        :id ,id
        :text ,text)
      :onclick onclick-value))))

#+repl (encode-create-button "Hello")
#+repl (encode-create-button "JS" :onclick "function(){alert('hi');}")
#+repl (encode-create-button "PS" :onclick '(lambda () (alert "hi from parenscript")))
#+repl (encode-create-button "Lisp" :onclick (lambda (elt payload)
                                               (declare (ignore elt payload))
                                               (format t "~&clicked~%")))

(defun encode-create-input (&key
                              (id (make-element-id))
                              (value "")
                              (onchange nil))
  "Encodes a create-input message for the browser.

Creates a text input element. VALUE is its initial contents. ID is a
KSUID string; a fresh one is minted if not supplied. ONCHANGE selects
one of four change-handler lanes; see the commentary above
ENCODE-EVENT-HANDLER for the dispatch rules.

The change event fires when the user commits a new value (typically
on blur or Enter). The current text reaches the handler via different
paths per lane:

  FUNCTION lane: the handler is a Lisp function of (element payload).
    The payload plist carries :value, so handlers read it as
    (getf payload :value).

  STRING / CONS (literal JS / Parenscript) lanes: the handler runs in
    the browser as a DOM event listener, so it receives the standard
    change event object. Handlers read the current text from the DOM
    directly -- e.target.value in literal JS, or (chain e target value)
    in Parenscript.

The asymmetry is deliberate: only the FUNCTION lane crosses the wire,
so only the FUNCTION lane needs a purpose-built payload. The STRING
and CONS lanes run in the browser where the DOM event is already in
scope, and inventing a synthetic payload for them would cost bytes
and a synchronization hazard for no gain.

Returns the JSON string to ship over the websocket."
  (let* ((element (make-element "input" :id id))
         (onchange-value (encode-event-handler element :change onchange)))
    (cl-json:encode-json-plist-to-string
     (make-envelope-plist
      `(:type "create-element"
        :element-type "input"
        :id ,id
        :value ,value)
      :onchange onchange-value))))

#+repl (encode-create-input)
#+repl (encode-create-input :value "initial")
#+repl (encode-create-input :onchange "function(e){console.log(e.target.value);}")
#+repl (encode-create-input :onchange '(lambda (e) (chain console (log (chain e target value)))))
#+repl (encode-create-input                                  ; non-trivial PS handler:
        :onchange '(lambda (e)                               ; green bg if non-empty,
                     (let ((val (chain e target value)))     ; white otherwise.
                       (setf (chain e target style background-color)
                             (if (> (chain val length) 0)
                                 "#ccffcc"
                                 "#ffffff")))))
#+repl (encode-create-input :onchange (lambda (elt payload)
                                        (declare (ignore elt))
                                        (format t "~&input changed: ~S~%"
                                                (getf payload :value))))

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
