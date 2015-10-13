;;;; ***********************************************************************
;;;;
;;;; Name:          LOADVM.scm
;;;; Project:       Clio
;;;; Purpose:       Clio VM loader
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

;;; modify if the bard sources are at another pathname



(define $root  "/usr/local/src/clio/") ; osx

;;; ----------------------------------------------------------------------
;;; Scheme files to load for interactive development
;;; ----------------------------------------------------------------------

(define (paths prefix . suffixes)
  (map (lambda (suffix)(string-append prefix suffix))
       suffixes))

(define $sources
  (paths $root 
         "/src/version.scm"
         ))

;;; load sources
;;; ----------------------------------------------------------------------

(define (loadvm)
  (gc-report-set! #t)
  (for-each (lambda (f)(load f))
            $sources))

;;; (loadvm)

