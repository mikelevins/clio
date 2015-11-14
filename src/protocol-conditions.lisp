;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-conditions.lisp
;;;; Project:       the clio language
;;;; Purpose:       creating and operating on conditions
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

#|

;; variables

*break-on-signals*
*debugger-hook*

;; functions

abort
break
cell-error-name
cerror
compute-restarts
continue
error
find-restart
invalid-method-error
invoke-debugger
invoke-restart
invoke-restart-interactively
make-condition
method-combination-error
muffle-warning
restart-name
signal
simple-condition-format-arguments
simple-condition-format-control
store-value
use-value
warn

;; macros

assert
check-type
define-condition
handler-bind
handler-case
ignore-errors
restart-bind
restart-case
with-condition-restarts
with-simple-restart

|#
