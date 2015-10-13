;;;; ***********************************************************************
;;;;
;;;; Name:          instructions.scm
;;;; Project:       Clio
;;;; Purpose:       implementations of Clio vm instructions
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************


(define +instructions+
  (vector
   ;; HALT
   (lambda (vm)
     (vm:set-halted! vm #t))                             
   ;; LREF
   (lambda (vm frame var)
     (vm:push! vm (vm:lvar-ref vm frame var)))
   ;; LSET
   (lambda (vm frame var)
     (vm:lvar-set! vm frame var (vm:top vm)))  
   ;; GREF
   (lambda (vm vname)
     (vm:push! vm (vm:gref vm vname)))                   
   ;; GSET
   (lambda (vm vname)
     (vm:gset! vm vname (vm:top vm)))              
   ;; POP
   (lambda (vm)
     (vm:pop! vm))                                       
   ;; CONST
   (lambda (vm c)
     (vm:push! vm c))                                  
   ;; JUMP
   (lambda (vm dest)
     (vm:set-pc! vm dest))                               
   ;; FJUMP
   (lambda (vm dest)
     (if (false? (vm:pop! vm)) (vm:set-pc! vm dest)))    
   ;; TJUMP
   (lambda (vm dest)
     (if (true? (vm:pop! vm)) (vm:set-pc! vm dest)))     
   ;; SAVE
   (lambda (vm addr)                                               
     (vm:push! vm                         
               (vm:make-return-record pc: addr
                                      method: (vm:method vm)
                                      env: (vm:env vm))))
   ;; RETURN
   (lambda (vm)
     (let ((ret (vm:stack-ref vm 1))
           (meth (return-record-method ret)))
       (vm:set-method! vm meth)
       (vm:set-code! vm (vm:method-code meth))
       (vm:set-env! vm (return-record-environment ret))
       (vm:set-pc! vm (return-record-pc ret))
       ;; discard the return address and keep the value
       (vm:swap! vm)
       (vm:pop! vm)))
   ;; NARGS
   (lambda (vm n)
     (vm:set-argcount! vm n))
   ;; CALLJ
   (lambda (vm argcount)
     (vm:pop! vm)
     (vm:set-method! (vm:pop! vm))
     (vm:set-code! (vm:method-code (vm:method vm)))
     (vm:set-env! vm (vm:method-environment (vm:method vm)))
     (vm:set-pc! vm 0)
     (vm:set-argcount! vm argcount))
   ;; ARGS
   (lambda (vm nargs)
     (let ((argcount (vm:argcount vm)))
       (if (= argcount nargs)
           (vm:add-args-to-env! vm nargs)
           (error (string-append "Wrong number of arguments; " 
                                 (object->string nargs) " expected; "
                                 (object->string argcount) " supplied.")))))
   ;; ARGS.
   (lambda (vm nargs)
     (let ((argcount (vm:argcount vm)))
       (if (>= argcount nargs)
           (vm:add-varargs-to-env! vm nargs argcount)
           (error (string-append "Wrong number of arguments; " 
                                 (object->string nargs) " or more expected; "
                                 (object->string argcount) " supplied.")))))
   ;; METHOD
   (lambda (vm m)
     (vm:push! vm (vm:make-method code: (vm:method-code m)
                                  env: (vm:env vm))))
   ;; PRIM
   (lambda (vm op)
     (let ((n-args (vm:argcount vm)))
       (let loop ((i 0)
                  (args '()))
         (if (>= i n-args)
             (vm:push! vm (apply op args))
             (loop (+ i 1)(cons (vm:pop! vm) args))))))
   ;; TRUE
   (lambda (vm)(vm:push! vm #t))
   ;; FALSE
   (lambda (vm)(vm:push! vm #f))
   ;; MINUSONE
   (lambda (vm)(vm:push! vm -1))
   ;; ZERO
   (lambda (vm)(vm:push! vm 0))
   ;; ONE
   (lambda (vm)(vm:push! vm 1))
   ;; TWO
   (lambda (vm)(vm:push! vm 2))
   ;; NIL
   (lambda (vm)
     (vm:push! vm (vm:%empty-list)))
   ;; CONS
   (lambda (vm)
     (let ((tl (vm:pop! vm))(hd (vm:pop! vm)))
       (vm:push! vm (vm:%cons hd tl))))
   ;; CAR
   (lambda (vm)(vm:push! vm (vm:%car (vm:pop! vm))))
   ;; CDR
   (lambda (vm)(vm:push! vm (vm:%cdr (vm:pop! vm))))
   ;; EQ
   (lambda (vm)
     (vm:push! vm (vm:%eq (vm:pop! vm)(vm:pop! vm))))))
