;;;; ***********************************************************************
;;;; 
;;;; Name:          build.lisp
;;;; Project:       clio
;;;; Purpose:       code to build the cliocl executable
;;;; Author:        mikel evins
;;;; Copyright:     2021 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl-user)

(defun build-clio ()
  (asdf:load-system :cliocl)
  )
