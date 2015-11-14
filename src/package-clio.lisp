;;;; ***********************************************************************
;;;;
;;;; Name:          package-clio.lisp
;;;; Project:       the clio language
;;;; Purpose:       public API package
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

;;; ---------------------------------------------------------------------
;;; package clio
;;; ---------------------------------------------------------------------
;;; the package that provides the Clio surface language
;;; it imports only the exported symbols from clio-internal
;;; and exports Clio's public APIs

(defpackage :clio
  (:use :clio-internal)

  (:shadow)

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



