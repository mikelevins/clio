;;;; ***********************************************************************
;;;;
;;;; Name:          list-syntax.lisp
;;;; Project:       the clio language
;;;; Purpose:       syntactic convenience for lists 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl)

(eval-when (:compile-toplevel :load-toplevel :execute)
  (set-macro-character #\[
                          (lambda (stream char)
                            (declare (ignore char))
                            (let ((elts (read-delimited-list #\] stream t)))
                              `(list ,@elts)))))

(eval-when (:compile-toplevel :load-toplevel :execute)
 (set-macro-character #\] (get-macro-character #\))))

