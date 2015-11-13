
;;; ---------------------------------------------------------------------
;;; package clio-internal
;;; ---------------------------------------------------------------------
;;; the package in which clio is implemented.
;;; it imports all of common-lisp, shoadwing symbols where
;;; necessary, and exporting thse symbols that are part of clio
(defpackage :clio-internal
  (:use :cl)
  (:shadow
   #:append
   #:class
   #:count-if
   #:eighth
   #:fifth
   #:find-if
   #:first
   #:fourth
   #:last
   #:length
   #:map
   #:mismatch
   #:ninth
   #:position-if
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
   )
  (:import-from :fset
                #:seq)
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
   #:+
   #:-
   #:*
   #:/
   #:random

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
   #:generate
   #:iota
   #:scan
   
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
   #:select
   #:unzip
   #:zip

   ;; types
   #:class
   
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
   #:+
   #:-
   #:*
   #:/
   #:random

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
   #:generate
   #:iota
   #:scan
   
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
   #:select
   #:unzip
   #:zip

   ;; types
   #:class
   
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

