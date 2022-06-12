;;;; ***********************************************************************
;;;; 
;;;; Name:          app.lisp
;;;; Project:       clio
;;;; Purpose:       code to launch the neutralino binary with appropriate arguments
;;;; Author:        mikel evins
;;;; Copyright:     2021 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cliocl)

(defparameter +clio-root+ (asdf:system-relative-pathname :cliocl ""))
(defparameter +neutralino-path+
  #+(or macos darwin)
  (asdf:system-relative-pathname :cliocl "bin/neutralino-mac_x64"))

(defun runapp (&key (port 8000))
  (let ((args (list "--load-dir-res"
                    (format nil "--path=~A" (namestring +clio-root+))
                    "--mode=window"
                    (format nil "--port=~A" port))))
    #+(or macos darwin)
    (sb-ext:run-program +neutralino-path+ args)
    #+(or win32 mswindows windows)
    (sb-ext:run-program "start chrome" args)
    #+linux
    (sb-ext:run-program "/usr/bin/google-chrome" args)))

#+nil (runapp :port 10101)
