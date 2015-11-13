
(defpackage #:clio
  (:use)
  (:import-from :cl
                #:+
                #:-
                #:*
                #:/
                #:=
                #:<
                #:<=
                #:>
                #:>=
                #:&allow-other-keys
                #:&body
                #:&key
                #:&optional
                #:&rest
                #:and
                #:apply
                #:character
                #:cond
                #:cons
                #:defgeneric
                #:defmacro
                #:defmethod
                #:error
                #:if
                #:integer
                #:lambda
                #:list
                #:nil
                #:not
                #:null
                #:or
                #:pathname
                #:quote
                #:stream
                #:string
                #:t
                #:unless
                #:values
                #:vector
                #:when
                )
  (:import-from :fset
                #:seq)
  (:export))

