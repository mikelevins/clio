;;;; ***********************************************************************
;;;;
;;;; Name:          list-syntax.lisp
;;;; Project:       the clio language
;;;; Purpose:       syntactic convenience for lists 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(cl:eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:set-macro-character #\[
                          (lambda (stream char)
                            (cl:declare (cl:ignore char))
                            (cl:let ((elts (cl:read-delimited-list #\] stream t)))
                              `(cl:list ,@elts)))))

(cl:eval-when (:compile-toplevel :load-toplevel :execute)
 (cl:set-macro-character #\] (cl:get-macro-character #\))))

