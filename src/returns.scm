;;;; ***********************************************************************
;;;;
;;;; Name:          returns.scm
;;;; Project:       Clio
;;;; Purpose:       representation of return records for function calls
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

;;; ---------------------------------------------------------------------
;;; the return type object
;;; ---------------------------------------------------------------------

(define <return>
  (vector '<return> 'pc 'method 'env))

;;; ---------------------------------------------------------------------
;;; the return constructor
;;; ---------------------------------------------------------------------

(define (make-return #!key
                     (pc 0)
                     (method #f)
                     (env #f))
  (vector <return> pc method env))

;;; ---------------------------------------------------------------------
;;; return predicate
;;; ---------------------------------------------------------------------

(define (return? thing)
  (and (vector? thing)
       (> (vector-length thing) 0)
       (eqv? <return> (vector-ref thing 0))))

;;; ---------------------------------------------------------------------
;;; return private accessors
;;; ---------------------------------------------------------------------

;;; slot offsets

(define RETURN.PC 1)
(define RETURN.METHOD 2)
(define RETURN.ENV 3)

;;; ---------------------------------------------------------------------
;;; method public accessors
;;; ---------------------------------------------------------------------

(define (return:pc m)(vector-ref m RETURN.PC))
(define (return:set-pc! m code)(vector-set! m RETURN.PC code))
(define (return:method m)(vector-ref m RETURN.METHOD))
(define (return:set-method! m code)(vector-set! m RETURN.METHOD code))
(define (return:env m)(vector-ref m RETURN.ENV))
(define (return:set-env! m code)(vector-set! m RETURN.ENV code))


