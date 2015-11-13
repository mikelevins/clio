;;;; ***********************************************************************
;;;;
;;;; Name:          tap.lisp
;;;; Project:       the clio language
;;;; Purpose:       creating and manipulating streams of values 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

(cl:defparameter +whitespace-characters+
  '(#\space #\tab #\return #\newline #\vt #\formfeed))

(cl:defparameter +line-break-characters+
  '(#\return #\newline #\formfeed))

(defmethod tap ((type (cl:eql :bytes))(source stream) &key &allow-other-keys)
  (series:scan-stream source #'cl:read-byte))

(defmethod tap ((type (cl:eql :characters))(source stream) &key &allow-other-keys)
  (series:scan-stream source #'cl:read-char))

(defmethod tap ((type (cl:eql :words))(source stream)
                &key (word-break-characters +whitespace-characters+)
                  &allow-other-keys)
  (cl:let* ((chars (series:scan-stream source #'cl:read-char))
            (break-flags (series:map-fn t (lambda (ch)
                                            (cl:member ch word-break-characters))
                                        chars))
            (break-positions (series:positions break-flags))
            (break-positions0 (series:catenate (series:scan '(-1))
                                               break-positions))
            (break-positions1 (series:catenate break-positions
                                               (series:scan '(nil))))
            (chunks (series:map-fn t (lambda (x y)
                                       (if y
                                           (series:subseries chars (cl:1+ x) y)
                                           (series:subseries chars (cl:1+ x))))
                                   break-positions0
                                   break-positions1)))
    (series:map-fn t (lambda (s)(series:collect 'string s))
                   chunks)))

(defmethod tap ((type (cl:eql :lines))(source stream)
                &key (line-break-characters +line-break-characters+)
                  &allow-other-keys)
  (series:scan-stream source #'cl:read-line))

(defmethod tap ((type (cl:eql :objects))(source stream)
                &key &allow-other-keys)
  (series:scan-stream source #'read))

(defgeneric tap (element-type source &key &allow-other-keys))

(defmethod tap ((type (cl:eql :characters))(source string) &key &allow-other-keys)
  (series:scan source))

(defmethod tap ((type (cl:eql :words))(source string)
                &key (word-break-characters +whitespace-characters+)
                  &allow-other-keys)
  (cl:with-input-from-string (in source)
    (tap :words in)))

(defmethod tap ((type (cl:eql :lines))(source string)
                &key (line-break-characters +line-break-characters+)
                  &allow-other-keys)
  (cl:with-input-from-string (in source)
    (tap :lines in)))

(defmethod tap ((type (cl:eql :objects))(source string)
                &key &allow-other-keys)
  (cl:with-input-from-string (in source)
    (tap :objects in)))


(defmethod tap ((type (cl:eql :bytes))(source pathname) &key &allow-other-keys)
  (cl:with-open-file (in source :direction :input
                         :element-type '(unsigned-byte 8))
    (tap :bytes in)))

(defmethod tap ((type (cl:eql :characters))(source pathname) &key &allow-other-keys)
  (cl:with-open-file (in source :direction :input
                         :element-type 'character)
    (tap :characters in)))

(defmethod tap ((type (cl:eql :words))(source pathname)
                &key (word-break-characters +whitespace-characters+)
                  &allow-other-keys)
  (cl:with-open-file (in source :direction :input
                         :element-type 'character)
    (tap :words in)))

(defmethod tap ((type (cl:eql :lines))(source pathname)
                &key (line-break-characters +line-break-characters+)
                  &allow-other-keys)
  (cl:with-open-file (in source :direction :input
                         :element-type 'character)
    (tap :lines in)))

(defmethod tap ((type (cl:eql :objects))(source pathname)
                &key &allow-other-keys)
  (cl:with-open-file (in source :direction :input
                         :element-type 'character)
    (tap :objects in)))

(defmethod tap ((type (cl:eql :keys))(source cl:hash-table) &key &allow-other-keys)
  (cl:multiple-value-bind (keys vals)(series:scan-hash source)
    keys))

(defmethod tap ((type (cl:eql :values))(source cl:hash-table) &key &allow-other-keys)
  (cl:multiple-value-bind (keys vals)(series:scan-hash source)
    vals))
