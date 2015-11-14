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

#|

;; variables

*RANDOM-STATE*

;; conditions

arithmetic-error
division-by-zero
floating-point-inexact
floating-point-invalid-operation
floating-point-overflow
floating-point-underflow

;; constants

pi

;; functions

*
+
-
/
/=
<
<=
=
>
>=
abs
acos
acosh
asin
asinh
atan
atanh
ceiling
complex
complex?
conjugate
cos
cosh
dec
decode-float
denominator
even?
exp
expt
fceiling
ffloor
float
float-digits
float-precision
float-radix
float-sign
float?x
floor
fround
ftruncate
gcd
imaginary-part
inc
integer-decode-float
integer-length
integer?
isqrt
lcm
make-random-state
max
min
minus?
mod
number?
numerator
odd?
parse-integer
phase
plus?
random
random-state?
rational
rationalize
rational?
real?
realpart
rem
round
scale-float
sign
sin
sinh
sqrt
tan
tanh
truncate
zero?

|#
