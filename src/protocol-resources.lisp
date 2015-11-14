;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-resources.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations files and other sources of data 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric probe (resource &key &allow-other-keys))

#|

;; variables

;; conditions

uri-parse-error

;; classes

uri
urn

;; functions

copy-uri
enough-uri
make-uri-space
merge-uris
parse-uri
render-uri
uri
uri-authority
uri-escaped
uri-fragment
uri-hashcode
uri-host
uri-parsed-path
uri-path
uri-plist
uri-port
uri-query
uri-scheme
uri-space
uri-string
uri?
urn-nid
urn-nss


|#
