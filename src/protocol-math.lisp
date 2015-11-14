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

;; classes

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
signed-byte
single-float
specifier mod
unsigned-byte

;; conditions

arithmetic-error
division-by-zero
floating-point-inexact
floating-point-invalid-operation
floating-point-overflow
floating-point-underflow

;; constants

boole-1
boole-2
boole-and
boole-andc1
boole-andc2
boole-c1
boole-c2
boole-clr
boole-eqv
boole-ior
boole-nand
boole-nor
boole-orc1
boole-orc2
boole-set
boole-xor
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
ash
asin
asinh
atan
atanh
boole
byte
byte-position
byte-size
ceiling
cis
complex
complexp
conjugate
cos
cosh
decode-float
denominator
deposit-field
dpb
evenp
exp
expt
fceiling
ffloor
float
float-digits
float-precision
float-radix
float-sign
floatp
floor
fround
ftruncate
gcd
imagpart
integer-decode-float
integer-length
integerp
isqrt
lcm
ldb-test
log
logand
logandc1
logandc2
logbitp
logcount
logeqv
logior
lognand
lognor
lognot
logorc1
logorc2
logtest
logxor
make-random-state
max
min
minusp
mod
numberp
numerator
oddp
parse-integer
phase
plusp
random
random-state-p
rational
rationalize
rationalp
realp
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
zerop

;; macros

decf
incf

|#
