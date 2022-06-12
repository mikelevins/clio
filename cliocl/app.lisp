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
  (asdf:system-relative-pathname :cliocl "bin/neutralino-mac_x64")
  #+(or win32 mswindows windows)
  (asdf:system-relative-pathname :cliocl "bin/neutralino-win_x64.exe")
  #+linux
  (asdf:system-relative-pathname :cliocl "bin/neutralino-linux_x64"))

;;; see https://neutralino.js.org/docs/cli/internal-cli-arguments/
;;; for documentation of the neutralinojs internal CLI arguments

(defun runapp (&key (port 8000))
  (let ((args (list "--load-dir-res"
                    "--mode=window"
                    "--window-title=clio"
                    "--enable-extensions=true"
                    (format nil "--path=~A" (namestring +clio-root+))
                    (format nil "--port=~A" port))))
    (sb-ext:run-program +neutralino-path+ args)))

#+nil (runapp :port 10101)
