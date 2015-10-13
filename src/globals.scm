;;;; ***********************************************************************
;;;;
;;;; Name:          globals.scm
;;;; Project:       Clio
;;;; Purpose:       representation of global variables
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(define (vm:make-globals)(make-table test: eq?))

(define +absent+ (cons 'absent '()))

(define (vm:gref vm var)
  (table-ref (vm:globals vm) var +absent+))

(define (vm:gset! vm var val)
  (table-set! (vm:globals vm) var val))

