;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-bytes.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on bits and bytes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric logbit? (byte))

#| exported from common lisp

;; variables

*random-state*

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

;; types and classes

bit
signed-byte
unsigned-byte

;; functions

ash
boole
byte
byte-position
byte-size
deposit-field
dpb
integer-length
ldb
ldb-test
logand
logandc1
logandc2
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
mask-field

|#
