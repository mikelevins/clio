;;;; ***********************************************************************
;;;;
;;;; Name:          utilities.lisp
;;;; Project:       Clio
;;;; Purpose:       general-purpose utilities
;;;; Author:        mikel evins
;;;; Copyright:     2018 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;;  GENERIC-FUNCTION file-pathname-p (pathname)
;;; ---------------------------------------------------------------------
;;; returns true if the pathname's name or type part is nonempty
;;; does not check whether the named file actually exists

(defmethod file-pathname-p ((pathname pathname))
  (when pathname
    (let* ((pathname (pathname pathname))
           (name (pathname-name pathname))
           (type (pathname-type pathname)))
      (when (or (not (member name '(nil :unspecific "") :test 'equal))
                (not (member type '(nil :unspecific "") :test 'equal)))
        pathname))))

(defmethod file-pathname-p ((path string))
  (file-pathname-p (pathname path)))


;;;  GENERIC-FUNCTION directory-pathname-p (pathname)
;;; ---------------------------------------------------------------------
;;; returns true if the pathname's name and type part are empty
;;; and the directory part is not
;;; does not check whether the named directory actually exists

(defmethod directory-pathname-p ((pathname pathname))
  (when pathname
    (let* ((pathname (pathname pathname))
           (dir (pathname-directory pathname))
           (name (pathname-name pathname))
           (type (pathname-type pathname)))
      (when (and dir
                 (member name '(nil :unspecific "") :test 'equal)
                 (member type '(nil :unspecific "") :test 'equal))
        pathname))))

(defmethod directory-pathname-p ((path string))
  (directory-pathname-p (pathname path)))
