;;;; ***********************************************************************
;;;;
;;;; Name:          package-clio-internal.lisp
;;;; Project:       the clio language
;;;; Purpose:       private implementation package
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

;;; ---------------------------------------------------------------------
;;; package clio-internal
;;; ---------------------------------------------------------------------
;;; the package in which clio is implemented.  it imports all of
;;; common-lisp, shadowing symbols as-needed, and exporting the
;;; symbols that are part of clio

(defpackage :clio-internal
  (:use :cl)

  (:shadowing-import-from :fset
                          #:map)
  
  (:shadow
   #:<
   #:<=
   #:=
   #:>
   #:>=
   #:append
   #:class
   #:close
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
   #:open
   #:ninth
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
   #:sort ; NOTE: non-destructive!
   #:substitute-if
   #:tenth
   #:third
   #:type
   #:write)

  (:export
   #:$
   #:^
   #:<
   #:<=
   #:=
   #:>
   #:>=
   #:append
   #:begin
   #:class
   #:close
   #:count-if
   #:define
   #:eighth
   #:fifth
   #:find-if
   #:first
   #:fourth
   #:get
   #:last
   #:length
   #:make
   #:map
   #:merge
   #:mismatch
   #:open
   #:ninth
   #:position-if
   #:put
   #:read
   #:reduce
   #:remove-duplicates
   #:remove-if
   #:rest
   #:return-from
   #:reverse
   #:search
   #:second
   #:set!
   #:seventh
   #:sixth
   #:sort ; NOTE: non-destructive!
   #:substitute-if
   #:tenth
   #:third
   #:type
   #:write))
