;;;; ***********************************************************************
;;;;
;;;; Name:          opcodes.scm
;;;; Project:       Clio
;;;; Purpose:       definitions of vm opcodes
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(define HALT 0)
(define LREF 1)
(define LSET 2)
(define GREF 3)
(define GSET 4)
(define POP 5)
(define CONST 6)
(define JUMP 7)
(define FJUMP 8)
(define TJUMP 9)
(define SAVE 10)
(define RETURN 11)
(define NARGS 12)
(define CALLJ 13)
(define ARGS 14)
(define ARGS. 15)
(define METHOD 16)
(define PRIM 17)
(define TRUE 18)
(define FALSE 19)
(define MINUSONE 20)
(define ZERO 21)
(define ONE 22)
(define TWO 23)
(define NIL 24)
(define CONS 25)
(define CAR 26)
(define CDR 27)
(define EQ 28)

(define +instruction-names+
  (vector
   "HALT"
   "LREF"
   "LSET"
   "GREF"
   "GSET"
   "POP"
   "CONST"
   "JUMP"
   "FJUMP"
   "TJUMP"
   "SAVE"
   "RETURN"
   "NARGS"
   "CALLJ"
   "ARGS"
   "ARGS."
   "METHOD"
   "PRIM"
   "TRUE"
   "FALSE"
   "MINUSONE"
   "ZERO"
   "ONE"
   "TWO"
   "NIL"
   "CONS"
   "CAR"
   "CDR"
   "EQ"))

(define (opcode->name opcode)
  (vector-ref +instruction-names+ opcode))
