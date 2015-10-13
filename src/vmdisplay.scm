;;;; ***********************************************************************
;;;;
;;;; Name:          vmdisplay.scm
;;;; Project:       Clio
;;;; Purpose:       tools for displaying the state of the vm
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(define (vm:show-code vm #!key (pad ""))
  (let* ((code (vm:code vm)))
    (if code
        (let ((len (vector-length code)))
          (let loop ((i 0))
            (if (< i len)
                (let ((instr (vector-ref code i)))
                  (newline)
                  (display pad)
                  (display "  ")
                  (display i)
                  (display " ")
                  (display (object->string instr))
                  (loop (+ i 1))))))
        #f)))

(define (vm:show-env vm #!key (pad ""))
  (let ((env (vm:env vm)))
    (if env
        (let ((len (length env)))
          (display pad)
          (display "[")
          (if (> len 0)
              (let outer-loop ((i 0))
                (if (< i len)
                    (let* ((fr (list-ref env i))
                           (l (vector-length fr)))
                      (newline)
                      (display pad)
                      (display "  frame ")
                      (display i)
                      (display ": ")
                      (let inner-loop ((j 0))
                        (if (< j l)
                            (let ((val (vector-ref fr j)))
                              (newline)
                              (display pad)
                              (display "    var ")
                              (display j)
                              (display ": ")
                              (display val)
                              (inner-loop (+ j 1)))))
                      (outer-loop (+ i 1)))
                    (newline))))
          (display pad)
          (display "]")
          (newline))
        #f)))

(define (vm:show-pc vm)
  (let* ((pc (vm:pc vm)))
    (display "pc: ")
    (display (object->string pc))))

(define (vm:show-instruction vm)
  (let* ((ins (vm:instruction vm)))
    (display "instruction: ")
    (display (object->string ins))))

(define (%stack->string s)
  (object->string s))

(define (vm:show-stack vm)
  (let* ((stack (vm:stack vm)))
    (display "stack: ")
    (display (%stack->string stack))))

(define (vm:display vm #!key 
                    (show-code #f)
                    (show-env #f)
                    (indent 0))
  (let ((pad (make-string indent #\space)))
    (if show-code 
        (begin
          (newline)
          (display pad)
          (display "code:")
          (vm:show-code vm pad: pad)
          (newline)))
    (if show-env 
        (begin
          (newline)
          (display pad)
          (display "env: ")
          (vm:show-env vm pad: pad)))
    (display pad)
    (vm:show-pc vm)
    (display " ")
    (vm:show-instruction vm)
    (display " halted: ")
    (display (object->string (vm:halted? vm)))
    (newline)
    (display pad)
    (vm:show-stack vm)
    (newline)))
