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
(defgeneric even? (thing))
(defgeneric float? (thing))
(defgeneric integer? (thing))
(defgeneric minus? (thing))
(defgeneric number? (thing))
(defgeneric odd? (thing))
(defgeneric plus? (thing))
(defgeneric random-state? (thing))
(defgeneric rational? (thing))
(defgeneric real? (thing))
(defgeneric zero? (thing))


#| exported from common-lisp

;; variables

*random-state*

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
imaginary-part
inc
integer-decode-float
integer-length
isqrt
lcm
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
sign
sin
sinh
sqrt
tan
tanh
truncate

|#



