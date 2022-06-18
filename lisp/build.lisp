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

(defparameter $binpath (asdf:system-relative-pathname :cliocl "cliocl"))

(defun build-clio ()
  (asdf:load-system :cliocl)
  (save-lisp-and-die $binpath
                     :executable t
                     :toplevel (lambda (&rest args)
                                 (format t "~%executable path = ~S" sb-ext:*core-pathname*)
                                 (format t "~%command-line args = ~S" sb-ext:*posix-argv*)
                                 (format t "~%toplevel args = ~S~%~%" args)
                                 (clio::start-server clio::*http-server-port*)
                                 (sb-impl::toplevel-init))))
