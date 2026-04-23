;;;; ***********************************************************************
;;;;
;;;; Name:          registry.lisp
;;;; Project:       clio: an HTTP presentation server for Lisp
;;;; Purpose:       bilateral element registry (Lisp side)
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

;;; ---------------------------------------------------------------------
;;; wire-format invariants
;;; ---------------------------------------------------------------------
;;; Clio-produced envelopes, in both directions, are JSON objects with
;;; unique keys. Both ends of the wire uphold this by construction:
;;;
;;;   Lisp side, outbound: all envelopes are produced by ENCODE-*
;;;   functions that call CL-JSON:ENCODE-JSON-PLIST-TO-STRING on a
;;;   literal plist. The plist-to-JSON path emits each key once.
;;;
;;;   Lisp side, inbound:  the alist returned by CL-JSON is converted
;;;   to a keyword-keyed plist by AS-MESSAGE-PAYLOAD (browser-api.lisp),
;;;   which signals an error on duplicate keys as a drift backstop.
;;;
;;;   JS side, outbound:   all messages are built as plain object
;;;   literals and shipped via sendObject. Object literals have unique
;;;   keys by language rule.
;;;
;;;   JS side, inbound:    JSON.parse discards duplicate keys by spec,
;;;   keeping only the last. The Lisp-side outbound invariant above
;;;   means this is not exercised in practice.
;;;
;;; Any change that produces envelopes by a path other than the above
;;; must preserve the uniqueness invariant.

;;; ---------------------------------------------------------------------
;;; element class
;;; ---------------------------------------------------------------------
;;; A clio-element is the Lisp-side handle for a rendered browser
;;; element. Its id is a KSUID string (27 base62 chars, time-sortable),
;;; so Lisp and the browser can each mint ids independently -- no
;;; coordination required, collision-free at any realistic scale,
;;; survives multi-client and multi-server without re-architecting.
;;;
;;; clio-element is a class rather than a struct so that element-type
;;; specializations (buttons, panels, charts, ...) can subclass it.

(defclass clio-element ()
  ((id :initarg :id
       :reader element-id
       :documentation "KSUID string identifying this element.")
   (element-type :initarg :element-type
                 :reader element-type
                 :documentation "Element kind, e.g. \"button\".")
   (metadata :initarg :metadata
             :initform nil
             :accessor element-metadata
             :documentation "Arbitrary plist of Clio-specific metadata.")
   (event-handlers :initarg :event-handlers
                   :initform '()
                   :accessor element-event-handlers
                   :documentation "Plist of event-name keywords to Lisp functions.")))

(defmethod print-object ((e clio-element) stream)
  (print-unreadable-object (e stream :type t :identity nil)
    (format stream "~A ~A" (element-type e) (element-id e))))

;;; ---------------------------------------------------------------------
;;; id minting
;;; ---------------------------------------------------------------------
;;; The browser side mints ids symmetrically in clio-ws.js using the
;;; same KSUID epoch constant (+ksuid-unix-epoch-seconds+), so ids
;;; round-trip byte-equal in both directions.

(defun make-element-id ()
  "Mints a fresh KSUID string for use as a Clio element id."
  (ksuid:ksuid->string (ksuid:make-ksuid)))

#+repl (make-element-id)

;;; ---------------------------------------------------------------------
;;; registry
;;; ---------------------------------------------------------------------
;;; *element-registry* maps id strings to clio-element instances.
;;; Lifecycle is explicit for now: callers register on creation and
;;; unregister when the element is removed. No GC, no reference
;;; counting, no parent-child tracking.
;;;
;;; Gotcha: like *message-handlers* in server.lisp, *element-registry*
;;; is reinitialized when this file is reloaded. A general fix for the
;;; reload problem will address both.

(defparameter *element-registry* (make-hash-table :test 'equal))

(defun register-element (element)
  "Registers ELEMENT in *element-registry*, keyed by its id.
Returns the element."
  (setf (gethash (element-id element) *element-registry*) element)
  element)

(defun lookup-element (id)
  "Returns the registered clio-element for ID, or NIL if none."
  (gethash id *element-registry*))

(defun unregister-element (id-or-element)
  "Removes the element identified by ID-OR-ELEMENT from the registry.
ID-OR-ELEMENT may be either a KSUID string or a clio-element instance.
Returns T if an entry was removed, NIL otherwise."
  (let ((id (if (typep id-or-element 'clio-element)
                (element-id id-or-element)
                id-or-element)))
    (remhash id *element-registry*)))

(defun make-element (element-type &key (id (make-element-id)) metadata)
  "Creates and registers a new clio-element of ELEMENT-TYPE.
If ID is supplied it is used verbatim; otherwise a fresh KSUID is
minted. Returns the registered element."
  (register-element
   (make-instance 'clio-element
                  :id id
                  :element-type element-type
                  :metadata metadata)))

#+repl (make-element "button")
#+repl (hash-table-count *element-registry*)
#+repl (loop for v being the hash-values of *element-registry* collect v)

;;; ---------------------------------------------------------------------
;;; per-element event handlers
;;; ---------------------------------------------------------------------
;;; When an element's browser-side interaction is handled by a Lisp
;;; function (as opposed to a JS string or Parenscript form shipped
;;; over the wire and evaluated in the browser), the Lisp function is
;;; stored on the element's EVENT-HANDLERS slot keyed by event name
;;; (e.g. :click, :mouseover). The browser-side onclick is a generic
;;; relay that sends an element-event message back to Lisp; the
;;; element-event dispatcher in browser-api.lisp looks the handler up
;;; here and funcalls it with the element and the message payload.

(defun register-event-handler (element event-name function)
  "Associates FUNCTION with EVENT-NAME (a keyword) on ELEMENT.
Returns the function."
  (setf (getf (element-event-handlers element) event-name) function)
  function)

(defun lookup-event-handler (element event-name)
  "Returns the handler function for EVENT-NAME on ELEMENT, or NIL."
  (getf (element-event-handlers element) event-name))

#+repl (let ((e (make-element "button")))
         (register-event-handler e :click (lambda (elt payload)
                                            (declare (ignore elt payload))
                                            (format t "~&clicked~%")))
         (lookup-event-handler e :click))
