
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
                #:defclass
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
                #:map
                #:seq)
  (:import-from :local-time
                #:now
                #:timestamp)
  (:import-from :puri
                #:parse-uri
                #:uri
                #:uri-host
                #:uri-path
                #:uri-port
                #:uri-query
                #:uri-scheme
                )
  (:export))

