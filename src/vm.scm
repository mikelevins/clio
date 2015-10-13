;;;; ***********************************************************************
;;;;
;;;; Name:          vm.scm
;;;; Project:       Clio
;;;; Purpose:       the Clio vm implementation
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

;;; ---------------------------------------------------------------------
;;; the vm type object
;;; ---------------------------------------------------------------------

(define <vm>
  (vector '<vm> 'halted 'method 'code 'pc 'globals 'env 'stack 'argcount 'instruction))

;;; ---------------------------------------------------------------------
;;; the vm constructor
;;; ---------------------------------------------------------------------

(define (make-vm #!key
                 (halted #f)
                 (method #f)
                 (code #f)
                 (pc 0)
                 (globals (vm:make-globals))
                 (env (env:null))
                 (stack '())
                 (argcount 0)
                 (instruction #f))
  (vector <vm>
          halted method code pc
          globals env stack argcount
          instruction))

;;; ---------------------------------------------------------------------
;;; vm predicate
;;; ---------------------------------------------------------------------

(define (vm? thing)
  (and (vector? thing)
       (> (vector-length thing) 0)
       (eqv? <vm> (vector-ref thing 0))))

;;; ---------------------------------------------------------------------
;;; vm private accessors
;;; ---------------------------------------------------------------------

;;; slot offsets

(define VM.HALTED 1)
(define VM.METHOD 2)
(define VM.CODE 3)
(define VM.PC 4)
(define VM.GLOBALS 5)
(define VM.ENV 6)
(define VM.STACK 7)
(define VM.ARGCOUNT 8)
(define VM.INSTRUCTION 9)

;;; ---------------------------------------------------------------------
;;; vm public accessors
;;; ---------------------------------------------------------------------

(define (vm:halted? vm)(vector-ref vm VM.HALTED))
(define (vm:set-halted! vm halted?)(vector-set! vm VM.HALTED halted?))
(define (vm:method vm)(vector-ref vm VM.METHOD))
(define (vm:set-method! vm method)(vector-set! vm VM.METHOD method))
(define (vm:code vm)(vector-ref vm VM.CODE))
(define (vm:set-code! vm code)(vector-set! vm VM.CODE code))
(define (vm:pc vm)(vector-ref vm VM.PC))
(define (vm:set-pc! vm pc)(vector-set! vm VM.PC pc))
(define (vm:globals vm)(vector-ref vm VM.GLOBALS))
(define (vm:set-globals! vm globals)(vector-set! vm VM.GLOBALS globals))
(define (vm:env vm)(vector-ref vm VM.ENV))
(define (vm:set-env! vm env)(vector-set! vm VM.ENV env))
(define (vm:stack vm)(vector-ref vm VM.STACK))
(define (vm:set-stack! vm stack)(vector-set! vm VM.STACK stack))
(define (vm:argcount vm)(vector-ref vm VM.ARGCOUNT))
(define (vm:set-argcount! vm argcount)(vector-set! vm VM.ARGCOUNT argcount))
(define (vm:instruction vm)(vector-ref vm VM.INSTRUCTION))
(define (vm:set-instruction! vm instruction)(vector-set! vm VM.INSTRUCTION instruction))

