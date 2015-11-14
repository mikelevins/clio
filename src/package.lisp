
;;; ---------------------------------------------------------------------
;;; package clio-internal
;;; ---------------------------------------------------------------------
;;; the package in which clio is implemented.
;;; it imports all of common-lisp, shoadwing symbols where
;;; necessary, and exporting thse symbols that are part of clio
(defpackage :clio-internal
  (:use :cl)
  (:shadow
   #:=
   #:<
   #:<=
   #:>
   #:>=
   #:append
   #:class
   #:count-if
   #:eighth
   #:fifth
   #:find-if
   #:first
   #:fourth
   #:get
   #:last
   #:length
   #:merge
   #:mismatch
   #:ninth
   #:open
   #:position-if
   #:put
   #:read
   #:reduce
   #:remove-duplicates
   #:remove-if
   #:rest
   #:reverse
   #:search
   #:second
   #:seventh
   #:sixth
   #:sort ; non-destructive!
   #:substitute-if
   #:tenth
   #:third
   #:type
   #:write
   )
  (:import-from :fset
                #:seq)
  (:shadowing-import-from :fset
                          #:map)
  (:import-from :series
                #:foundation-series)
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
  (:export
   ;; constants
   #:+clio-version+
   #:nil
   #:t

   ;; classes
   #:character
   #:cons
   #:float
   #:integer
   #:list
   #:null
   #:ratio
   #:seq
   #:series
   #:stream
   #:string
   #:symbol
   #:timestamp
   #:uri
   #:vector

   ;; special forms
   #:and
   #:apply
   #:begin
   #:cond
   #:defclass
   #:defgeneric
   #:define
   #:defmacro
   #:defmethod
   #:defun
   #:error
   #:if
   #:lambda
   #:not
   #:or
   #:quote
   #:return-from
   #:set!
   #:unless
   #:values
   #:when

   ;; math
   #:*
   #:*random-state*
   #:+
   #:-
   #:/
   #:abs
   #:acos
   #:acosh
   #:ash
   #:asin
   #:asinh
   #:atan
   #:atanh
   #:boole
   #:boole-1 
   #:boole-2 
   #:boole-and 
   #:boole-andc1 
   #:boole-andc2 
   #:boole-c1 
   #:boole-c2 
   #:boole-clr 
   #:boole-eqv 
   #:boole-ior 
   #:boole-nand 
   #:boole-nor 
   #:boole-orc1 
   #:boole-orc2
   #:boole-set 
   #:boole-xor 
   #:byte
   #:byte-position
   #:byte-size
   #:ceiling
   #:complex
   #:cos
   #:cosh
   #:dec
   #:decode-float
   #:denominator
   #:deposit-field
   #:dpb
   #:exp
   #:expt
   #:fceiling
   #:ffloor
   #:float
   #:float-digits
   #:float-precision
   #:float-radix
   #:float-sign
   #:floor
   #:fround
   #:ftruncate
   #:gcd
   #:imaginary-part
   #:inc
   #:integer-decode-float
   #:integer-length
   #:isqrt
   #:lcm
   #:ldb
   #:ldb-test
   #:log
   #:logandc1
   #:logandc2
   #:logbit?
   #:logcount
   #:logeqv
   #:logior
   #:lognand
   #:lognor
   #:lognot
   #:logorc1
   #:logorc2
   #:logxor
   #:make-random-state
   #:mask-field
   #:mod
   #:numerator
   #:phase
   #:pi
   #:quotient
   #:random
   #:random-state
   #:random-state?
   #:rational
   #:rationalize
   #:real-part
   #:rem
   #:remainder
   #:round
   #:scale-float
   #:sign
   #:sin
   #:sinh
   #:sqrt
   #:tan
   #:tanh
   #:truncate

   ;; comparison
   #:=
   #:<
   #:<=
   #:>
   #:>=

   ;; construction
   #:make

   ;; conversion
   #:as

   ;; functions
   #:$
   #:^
   #:call
   #:lambda

   ;; pairs
   #:left
   #:pair
   #:pair?
   #:right
   #:set-left!
   #:set-right!
   
   ;; sequences
   #:add-first
   #:add-last
   #:any
   #:append
   #:binary-append
   #:by
   #:count-if
   #:drop
   #:drop-until
   #:drop-while
   #:eighth
   #:element
   #:empty?
   #:every?
   #:fifth
   #:filter
   #:find-if
   #:first
   #:fourth
   #:indexes
   #:interleave
   #:interpose
   #:join
   #:last
   #:leave
   #:length
   #:mismatch
   #:map-over
   #:ninth
   #:partition
   #:penult
   #:position-if
   #:prefix-match?
   #:range
   #:reduce
   #:remove-duplicates
   #:remove-if
   #:rest
   #:reverse
   #:search
   #:second
   #:seq?   
   #:seventh
   #:shuffle
   #:sixth
   #:some?
   #:sort ; non-destructive!
   #:split
   #:subsequence
   #:substitute-if
   #:suffix-match?
   #:tail
   #:tails
   #:take
   #:take-by
   #:take-until
   #:take-while
   #:tenth
   #:third

   ;; series
   #:collect
   #:range-from
   #:tap
   
   ;; streams
   #:bytes
   #:characters
   #:close
   #:lines
   #:objects
   #:open
   #:read
   #:with-open
   #:words
   #:write

   ;; maps
   #:binary-merge
   #:get
   #:keys
   #:map
   #:merge
   #:pairs
   #:put
   #:select
   #:unzip
   #:vals
   #:zip

   ;; types
   #:class
   #:class?
   #:instance?
   #:subclass?
   #:subtype?
   #:type
   #:type?
   
   ;; time
   #:now

   ;; resources
   #:parse-uri
   #:probe
   #:uri-host
   #:uri-path
   #:uri-port
   #:uri-query
   #:uri-scheme
   
   ;; system
   #:gc
   #:room

   ))

;;; ---------------------------------------------------------------------
;;; package clio
;;; ---------------------------------------------------------------------
;;; the package that provides the Clio surface language
;;; it imports only the exported symbols from clio-internal
;;; and exports Clio's public APIs

(defpackage :clio
  (:use :clio-internal)
  (:export

   ;; constants
   #:+clio-version+
   #:nil
   #:t

   ;; classes
   #:character
   #:cons
   #:float
   #:foundation-series
   #:integer
   #:list
   #:null
   #:ratio
   #:seq
   #:stream
   #:string
   #:symbol
   #:timestamp
   #:uri
   #:vector

   ;; special forms
   #:and
   #:apply
   #:begin
   #:cond
   #:defclass
   #:defgeneric
   #:define
   #:defmacro
   #:defmethod
   #:defun
   #:error
   #:if
   #:lambda
   #:not
   #:or
   #:quote
   #:return-from
   #:set!
   #:unless
   #:values
   #:when

   ;; math
   #:*
   #:*random-state*
   #:+
   #:-
   #:/
   #:abs
   #:acos
   #:acosh
   #:ash
   #:asin
   #:asinh
   #:atan
   #:atanh
   #:boole
   #:boole-1 
   #:boole-2 
   #:boole-and 
   #:boole-andc1 
   #:boole-andc2 
   #:boole-c1 
   #:boole-c2 
   #:boole-clr 
   #:boole-eqv 
   #:boole-ior 
   #:boole-nand 
   #:boole-nor 
   #:boole-orc1 
   #:boole-orc2
   #:boole-set 
   #:boole-xor 
   #:byte
   #:byte-position
   #:byte-size
   #:ceiling
   #:complex
   #:cos
   #:cosh
   #:dec
   #:decode-float
   #:denominator
   #:deposit-field
   #:dpb
   #:exp
   #:expt
   #:fceiling
   #:ffloor
   #:float
   #:float-digits
   #:float-precision
   #:float-radix
   #:float-sign
   #:floor
   #:fround
   #:ftruncate
   #:gcd
   #:imaginary-part
   #:inc
   #:integer-decode-float
   #:integer-length
   #:isqrt
   #:lcm
   #:ldb
   #:ldb-test
   #:log
   #:logandc1
   #:logandc2
   #:logbit?
   #:logcount
   #:logeqv
   #:logior
   #:lognand
   #:lognor
   #:lognot
   #:logorc1
   #:logorc2
   #:logxor
   #:make-random-state
   #:mask-field
   #:mod
   #:numerator
   #:phase
   #:pi
   #:quotient
   #:random
   #:random-state
   #:random-state?
   #:rational
   #:rationalize
   #:real-part
   #:rem
   #:remainder
   #:round
   #:scale-float
   #:sign
   #:sin
   #:sinh
   #:sqrt
   #:tan
   #:tanh
   #:truncate

   ;; comparison
   #:=
   #:<
   #:<=
   #:>
   #:>=

   ;; construction
   #:make

   ;; conversion
   #:as

   ;; functions
   #:$
   #:^
   #:call
   #:lambda

   ;; pairs
   #:left
   #:pair
   #:pair?
   #:right
   #:set-left!
   #:set-right!
   
   ;; sequences
   #:add-first
   #:add-last
   #:any
   #:append
   #:binary-append
   #:by
   #:count-if
   #:drop
   #:drop-until
   #:drop-while
   #:eighth
   #:element
   #:empty?
   #:every?
   #:fifth
   #:filter
   #:find-if
   #:first
   #:fourth
   #:indexes
   #:interleave
   #:interpose
   #:join
   #:last
   #:leave
   #:length
   #:mismatch
   #:map-over
   #:ninth
   #:partition
   #:penult
   #:position-if
   #:prefix-match?
   #:range
   #:reduce
   #:remove-duplicates
   #:remove-if
   #:rest
   #:reverse
   #:search
   #:second
   #:seq?   
   #:seventh
   #:shuffle
   #:sixth
   #:some?
   #:sort ; non-destructive!
   #:split
   #:subsequence
   #:substitute-if
   #:suffix-match?
   #:tail
   #:tails
   #:take
   #:take-by
   #:take-until
   #:take-while
   #:tenth
   #:third

   ;; series
   #:collect
   #:range-from
   #:tap
   
   ;; streams
   #:bytes
   #:characters
   #:close
   #:lines
   #:objects
   #:open
   #:read
   #:with-open
   #:words
   #:write

   ;; maps
   #:binary-merge
   #:get
   #:keys
   #:map
   #:merge
   #:pairs
   #:put
   #:select
   #:unzip
   #:vals
   #:zip

   ;; types
   #:class
   #:class?
   #:instance?
   #:subclass?
   #:subtype?
   #:type
   #:type?
   
   ;; time
   #:now

   ;; resources
   #:parse-uri
   #:probe
   #:uri-host
   #:uri-path
   #:uri-port
   #:uri-query
   #:uri-scheme
   
   ;; system
   #:gc
   #:room
   ))

