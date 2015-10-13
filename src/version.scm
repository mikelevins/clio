;;;; ***********************************************************************
;;;;
;;;; Name:          version.scm
;;;; Project:       Clio
;;;; Purpose:       the Clio version string
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

;;; bard+clio-vm-version+
;;; ---------------------------------------------------------------------
;;; the version format is:
;;; major.minor.patch.build-number

(define +clio-version+ (vector 0 0 1 1))

(define (clio-version) +clio-version+)
(define (clio-major-version) (vector-ref +clio-version+ 0))
(define (clio-minor-version) (vector-ref +clio-version+ 1))
(define (clio-patch-version) (vector-ref +clio-version+ 2))
(define (clio-build-number) (vector-ref +clio-version+ 3))

(define (clio-version-string)
  (string-append (number->string (clio-major-version)) "."
                 (number->string (clio-minor-version)) "."
                 (number->string (clio-patch-version)) " (build "
                 (number->string (clio-build-number)) ")"))

;;; 
