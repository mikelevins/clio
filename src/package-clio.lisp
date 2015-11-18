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
   #:&allow-other-keys
   #:&key
   #:&optional
   #:&rest
   #:$
   #:^
   #:<
   #:<=
   #:=
   #:>
   #:>=
   #:and
   #:append
   #:apply
   #:begin
   #:class
   #:close
   #:count-if
   #:defclass
   #:define
   #:defun
   #:defmethod
   #:defpackage
   #:describe
   #:eighth
   #:eql
   #:fifth
   #:find-if
   #:first
   #:format
   #:fourth
   #:get
   #:if
   #:in-package
   #:last
   #:length
   #:let
   #:make
   #:make-instance
   #:map
   #:merge
   #:mismatch
   #:open
   #:or
   #:nil
   #:ninth
   #:null?
   #:position-if
   #:print-object
   #:print-unreadable-object
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
   #:stream
   #:substitute-if
   #:t
   #:tenth
   #:third
   #:type
   #:write))



