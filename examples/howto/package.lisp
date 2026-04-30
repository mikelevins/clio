;;;; ***********************************************************************
;;;;
;;;; Name:          package.lisp
;;;; Project:       clio-example-howto
;;;; Purpose:       package definition
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

;;; The :HOWTO nickname matches the entry points the HOWTO uses
;;; throughout: (howto:start), (howto:install-button), (howto:announce
;;; "..."). The full package name preserves the per-example naming
;;; convention used by hello/counters/htmx so the system, package, and
;;; directory share a name.

(defpackage #:clio-example-howto
  (:nicknames #:howto)
  (:use #:cl #:spinneret)
  (:export #:start
           #:install-button
           #:announce))
