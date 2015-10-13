;;;; ***********************************************************************
;;;;
;;;; Name:          env.scm
;;;; Project:       Clio
;;;; Purpose:       representation of lexical environments
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(define (env:null) '())

(define (env:add-frame env fr)
  (cons fr env))

(define (vm:add-args-to-env! vm nargs)
  (let ((fr (make-vector nargs)))
    (let loop ((i (- nargs 1)))
      (if (< i 0)
          (vm:set-env! vm (env:add-frame (vm:env vm) fr))
          (begin
            (vector-set! fr i (vm:pop! vm))
            (loop (- i 1)))))))

(define (vm:add-varargs-to-env! vm required-count supplied-count)
  (let loop ((i (- supplied-count 1))
             (restarg '())
             (required-args '()))
    (if (>= i required-count)
        (loop (- i 1)(cons (vm:pop! vm) restarg) required-args)
        (if (>= i 0)
            (loop (- i 1) restarg (cons (vm:pop! vm) required-args))
            (vm:set-env! vm
                         (env:add-frame (vm:env vm)
                                        (apply vector
                                               (append required-args
                                                       (list restarg)))))))))

(define (vm:lvar-ref vm frame-index var-index)
  (let ((env (vm:env vm)))
    (vector-ref (list-ref env frame-index) var-index)))

(define (vm:lvar-set! vm frame-index var-index val)
  (let ((env (vm:env vm)))
   (vector-set! (list-ref env frame-index) var-index val)))
