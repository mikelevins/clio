;;;; ***********************************************************************
;;;;
;;;; Name:          methods.scm
;;;; Project:       Clio
;;;; Purpose:       representation of compiled methods
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

;;; ---------------------------------------------------------------------
;;; the method type object
;;; ---------------------------------------------------------------------

(define <method>
  (vector '<method> 'code 'env 'debug-name))

;;; ---------------------------------------------------------------------
;;; the method constructor
;;; ---------------------------------------------------------------------

(define (make-method #!key
                     (code #f)
                     (env #f)
                     (debug-name #f))
  (vector <method> code env debug-name))

;;; ---------------------------------------------------------------------
;;; method predicate
;;; ---------------------------------------------------------------------

(define (method? thing)
  (and (vector? thing)
       (> (vector-length thing) 0)
       (eqv? <method> (vector-ref thing 0))))

;;; ---------------------------------------------------------------------
;;; method private accessors
;;; ---------------------------------------------------------------------

;;; slot offsets

(define METHOD.CODE 1)
(define METHOD.ENV 2)
(define METHOD.DEBUG-NAME 3)

;;; ---------------------------------------------------------------------
;;; method public accessors
;;; ---------------------------------------------------------------------

(define (method:code m)(vector-ref m METHOD.CODE))
(define (method:set-code! m code)(vector-set! m METHOD.CODE code))
(define (method:env m)(vector-ref m METHOD.ENV))
(define (method:set-env! m env)(vector-set! m METHOD.ENV env))
(define (method:debug-name m)(vector-ref m METHOD.DEBUG-NAME))
(define (method:set-debug-name! m name)(vector-set! m METHOD.DEBUG-NAME name))

