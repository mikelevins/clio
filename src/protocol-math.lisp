;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-math.lisp
;;;; Project:       the clio language
;;;; Purpose:       mathematical operations on numbers
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)


(defgeneric complex? (thing))
(defgeneric dec! (place))
(defgeneric even? (thing))
(defgeneric float? (thing))
(defgeneric inc! (place))
(defgeneric integer? (thing))
(defgeneric minus? (thing))
(defgeneric number? (thing))
(defgeneric odd? (thing))
(defgeneric plus? (thing))
(defgeneric random-state? (thing))
(defgeneric rational? (thing))
(defgeneric real? (thing))
(defgeneric zero? (thing))

#| re-exported from common lisp

;; variables

*random-state*

;; constants

double-float-epsilon
double-float-negative-epsilon
least-negative-double-float
least-negative-long-float
least-negative-normalized-double-float
least-negative-normalized-long-float
least-negative-normalized-short-float
least-negative-normalized-single-float
least-negative-short-float
least-negative-single-float
least-positive-double-float
least-positive-long-float
least-positive-normalized-double-float
least-positive-normalized-long-float
least-positive-normalized-short-float
least-positive-normalized-single-float
least-positive-short-float
least-positive-single-float
long-float-epsilon
long-float-negative-epsilon
most-negative-double-float
most-negative-fixnum
most-negative-long-float
most-negative-short-float
most-negative-single-float
most-positive-double-float
most-positive-fixnum
most-positive-long-float
most-positive-short-float
most-positive-single-float
pi
short-float-epsilon
short-float-negative-epsilon
single-float-epsilon
single-float-negative-epsilon

;; types and classes

bignum
complex
double-float
fixnum
float
integer
long-float
number
random-state
ratio
rational
real
short-float
single-float
specifier mod

;; conditions

arithmetic-error
division-by-zero
floating-point-inexact
floating-point-invalid-operation
floating-point-overflow
floating-point-underflow

;; functions

*
+
-
/
/=
1+
1-
<
<=
=
>
>=
abs
acos
acosh
arithmetic-error-operands
arithmetic-error-operation
asin
asinh
atan
atanh
ceiling
cis
complex
conjugate
cos
cosh
dec
decode-float
denominator
exp
expt
fceiling
ffloor
float
float-digits
float-precision
float-radix
float-sign
floor
fround
ftruncate
gcd
imagpart
inc
integer-decode-float
isqrt
lcm
log
make-random-state
max
min
mod
numerator
parse-integer
phase
random
rational
rationalize
realpart
rem
round
scale-float
signum
sin
sinh
sqrt
tan
tanh
truncate
upgraded-complex-part-type

|#
