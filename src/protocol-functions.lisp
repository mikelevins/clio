;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-functions.lisp
;;;; Project:       the clio language
;;;; Purpose:       creating and operating on functions
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

#|

;; conditions

control-error
program-error
undefined-function

;; constants

call-arguments-limit
lambda-list-keywords
lambda-parameters-limit
multiple-values-limit
nil
t

;; functions

apply
complement
constantly
every?
fbound?
funbind!
funcall
function?
identity
not
notany?
notevery?
some?
values
values-list

;; special forms and macros

and
begin
bind
case
catch
cond
define
defun
ensure
function
if
let
or
return-from
set!
throw
unless
when

|#
