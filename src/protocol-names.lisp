;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-names.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on names
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

#|

;; types and classes

logical-pathname
pathname
symbol
keyword

;; variables

*default-pathname-defaults*
*gensym-counter*

;; accessors

get
logical-pathname-translations
symbol-function
symbol-plist
symbol-value

;; conditions

unbound-variable

;; functions

boundp
copy-symbol
gensym
gentemp
intern
keywordp
load-logical-pathname-translations
logical-pathname
make-pathname
make-symbol
makunbound
merge-pathnames
namestring, file-namestring, directory-namestring, host-namestring, enough-namestring
parse-namestring
pathname
pathname-host, pathname-device, pathname-directory, pathname-name, pathname-type, pathname-version
pathname-match-p
pathnamep
remprop
set
symbol-name
symbol-package
symbolp
translate-logical-pathname
translate-pathname
unintern
wild-pathname-p

|#
