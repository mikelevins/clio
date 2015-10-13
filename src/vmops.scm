;;;; ***********************************************************************
;;;;
;;;; Name:          vm.scm
;;;; Project:       Clio
;;;; Purpose:       operations on the vm
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************


(define (vm:push! vm val)
  (vm:set-stack! vm (cons val (vm:stack vm))))

(define (vm:stack-ref vm n)(list-ref (vm:stack vm) n))

(define (vm:top vm)(vm:stack-ref vm 0))

(define (vm:pop! vm)
  (if (null? (vm:stack vm))
      (error "Stack underflow")
      (let ((out (vm:top vm)))
        (vm:set-stack! vm (cdr (vm:stack vm)))
        out)))

(define (vm:swap! vm)
  (let ((old-stack (vm:stack vm)))
    (vm:set-stack! vm 
                   (cons (cadr old-stack)
                         (cons (car old-stack)
                               (cddr old-stack))))))
