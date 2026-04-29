;;;; ***********************************************************************
;;;;
;;;; Name:          package.lisp
;;;; Project:       clio-example-counters
;;;; Purpose:       package definition
;;;; Author:        mikel evins
;;;; Copyright:     2026 by mikel evins
;;;;
;;;; ***********************************************************************

(defpackage #:clio-example-counters
  (:use #:cl #:spinneret)
  (:export #:start
           #:install-buttons))
