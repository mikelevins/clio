;;;; ***********************************************************************
;;;;
;;;; Name:          class-string.lisp
;;;; Project:       the clio language
;;;; Purpose:       protocol implementations for the string class
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; NOTE:
;;; we want a generic function named string, so we
;;; shadow that symbol from CL and cause it to refer to
;;; the CL class of the same name.
(eval-when (:compile-toplevel :load-toplevel :execute)
  (cl:setf (cl:find-class 'clio-internal::string)
           (cl:find-class 'cl::string)))

;;; ---------------------------------------------------------------------
;;; protocol: construction
;;; ---------------------------------------------------------------------

(defmethod %make-string-with-contents ((length null)(contents cl:string)
                                       &key (element-type 'cl:character))
  (cl:let ((buf (cl:make-string (cl:length contents) :element-type element-type)))
    (loop for i from 0 below (cl:length contents)
       do (setf (elt buf i)
                (elt contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents cl:sequence)
                                       &key (element-type 'cl:character))
  (assert (cl:every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (cl:let ((buf (cl:make-string (cl:length contents) :element-type element-type)))
    (loop for i from 0 below (cl:length contents)
       do (setf (elt buf i)
                (elt contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents seq)
                                       &key (element-type 'cl:character))
  (assert (fset::every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (cl:let ((buf (cl:make-string (fset:size contents) :element-type element-type)))
    (loop for i from 0 below (fset:size contents)
       do (setf (elt buf i)
                (fset:@ contents i)))
    buf))

(defmethod %make-string-with-contents ((length null)(contents foundation-series)
                                       &key (element-type 'cl:character))
  (cl:let ((contents* (series:collect contents)))
    (%make-string-with-contents (cl:length contents*) contents*
                                :element-type element-type)))

(defmethod %make-string-with-contents ((length integer)(contents cl:string)
                                       &key (element-type 'cl:character))
  (if (cl:eql length (cl:length contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (elt contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents cl:sequence)
                                       &key (element-type 'cl:character))
  (assert (cl:every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (if (cl:eql length (cl:length contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (elt contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents seq)
                                       &key (element-type 'cl:character))
  (assert (fset::every #'cl:characterp contents)()
          "Can't create a string with non-character contents")
  (if (cl:eql length (fset:size contents))
      (cl:let ((buf (cl:make-string length :element-type element-type)))
        (loop for i from 0 below length
           do (setf (elt buf i)
                    (fset:@ contents i)))
        buf)
      (error "length ~s doesn't match the length of ~S"
             length contents)))

(defmethod %make-string-with-contents ((length integer)(contents foundation-series)
                                       &key (element-type 'cl:character))
  (cl:let ((contents* (series:collect contents)))
    (%make-string-with-contents length contents*
                                :element-type element-type)))

(defmethod make ((type (eql 'string)) &rest initargs
                 &key
                   (length nil)
                   (contents nil contents?)
                   (element #\. element?)
                   (element-type 'cl:character)
                   &allow-other-keys)
  (if contents?
      (if element?
          (error "Can't specify both contents and element")
          (%make-string-with-contents length contents :element-type element-type))
      (cl:make-string length :initial-element element :element-type element-type)))

(defmethod make ((type (eql (cl:find-class 'cl:string))) &rest initargs
                 &key
                   (length nil)
                   (contents nil contents?)
                   (element #\. element?)
                   (element-type 'cl:character)
                   &allow-other-keys)
  (if contents?
      (if element?
          (error "Can't specify both contents and element")
          (%make-string-with-contents length contents :element-type element-type))
      (cl:make-string length :initial-element element :element-type element-type)))

(defmethod string (thing)(error "Can't convert ~S to a string" thing))
(defmethod string ((thing cl:string)) thing)
(defmethod string ((thing cl:character)) (cl:string thing))

;;; ---------------------------------------------------------------------
;;; protocol: conversion
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: equal
;;; ---------------------------------------------------------------------

(defmethod = ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string= thing1 thing2 more-things))

(defmethod identical? ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:eq thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: ordered
;;; ---------------------------------------------------------------------

(defmethod < ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string< thing1 thing2 more-things))

(defmethod <= ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string<= thing1 thing2 more-things))

(defmethod > ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string> thing1 thing2 more-things))

(defmethod >= ((thing1 string) (thing2 string) &rest more-things)
  (cl:apply #'cl:string>= thing1 thing2 more-things))

;;; ---------------------------------------------------------------------
;;; protocol: sequences
;;; ---------------------------------------------------------------------

;;; constructing

;;; (defgeneric add-first (thing sequence))
;;; (defgeneric add-last (sequence thing))
;;; (defgeneric append (sequence &rest sequences))

(defmethod append ((sequence cl:string) &rest sequences)
  (if (cl:null sequences)
      sequence
      (let* ((sequence2 (cl:first sequences))
             (more (cl:rest sequences)))
        (if more
            (cl:apply 'append (binary-append sequence sequence2)
                      more)
            (binary-append sequence sequence2)))))

(defmethod binary-append ((sequence1 cl:string) (sequence2 cl:string))
  (cl:concatenate 'cl:string sequence1 sequence2))

;;; (defgeneric collect (type series &key &allow-other-keys))
;;; (defgeneric generate (fn &key &allow-other-keys))
;;; (defgeneric interleave (sequence1 sequence2))
;;; (defgeneric interpose (thing sequence))
;;; (defgeneric join (sequence1 cupola sequence2))
;;; (defgeneric reverse (sequence))
;;; (defgeneric sequence->values (sequence))
;;; (defgeneric shuffle (sequence))
;;; (defgeneric substitute-if (test sequence new-value))
;;; (defgeneric tap (element-type source &key &allow-other-keys))

;;; filtering
;;; (defgeneric filter (test sequence))
;;; (defgeneric remove-duplicates (test sequence))
;;; (defgeneric remove-if (test sequence))

;;; mapping

;;; (defgeneric count-if (test sequence))
;;; (defgeneric every? (test sequence))
;;; (defgeneric indexes (sequence))
;;; (defgeneric map-over (function sequence))
;;; (defgeneric some? (test sequence))

;;; reducing
;;; (defgeneric reduce (function sequence &key &allow-other-keys))

;;; indexing

;;; (defgeneric eighth (sequence))
;;; (defgeneric element (sequence index))
;;; (defgeneric fifth (sequence))

(defmethod first ((sequence cl:string))
  (elt sequence 0))

;;; (defgeneric fourth (sequence))
;;; (defgeneric last (sequence))
;;; (defgeneric ninth (sequence))
;;; (defgeneric penult (sequence))
;;; (defgeneric second (sequence))
;;; (defgeneric seventh (sequence))
;;; (defgeneric sixth (sequence))
;;; (defgeneric tenth (sequence))
;;; (defgeneric third (sequence))

;;; destructuring

;;; (defgeneric any (sequence))
;;; (defgeneric by (count sequence))

(defmethod drop ((count cl:integer) (sequence cl:string))
  (cl:subseq sequence count))

;;; (defgeneric drop-until (test sequence))
;;; (defgeneric drop-while (test sequence))
;;; (defgeneric leave (count sequence))

(defmethod leave ((count cl:integer) (sequence cl:string))
  (cl:subseq sequence (- (cl:length sequence) count)))

;;; (defgeneric partition (function1 function2 sequence))
;;; (defgeneric rest (sequence))
;;; (defgeneric split (sequence pivot))
;;; (defgeneric subsequence (sequence start &optional end))
;;; (defgeneric tail (sequence))
;;; (defgeneric tails (sequence))

(defmethod take ((count cl:integer) (sequence cl:string))
  (cl:subseq sequence 0 count))

(defmethod take-by ((count integer) (offset integer) (sequence string))
  (loop for i from 0 upto (- (cl:length sequence) count) by offset
     collect (cl:subseq sequence i (+ i count))))

;;; (defgeneric take-until (test sequence))
;;; (defgeneric take-while (test sequence))

;;; properties

(defmethod length ((sequence string))
  (cl:length sequence))

;;; (defgeneric mismatch (sequence1 sequence2))

;;; predicates

;;; (defgeneric contains? (sequence value &key &allow-other-keys))
;;; (defgeneric empty? (sequence))
;;; (defgeneric prefix-match? (sequence1 sequence2))
;;; (defgeneric suffix-match? (sequence1 sequence2))

;;; searching

;;; (defgeneric find-if (test sequence))
;;; (defgeneric position-if (test sequence))
;;; (defgeneric search (sequence))

;;; sorting

;;; (defgeneric sort (test sequence)) ; non-destructive!

;;; ---------------------------------------------------------------------
;;; protocol: serialization
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: taps
;;; ---------------------------------------------------------------------
;;; ---------------------------------------------------------------------
;;; protocol: types
;;; ---------------------------------------------------------------------

(defmethod string? (thing) nil)
(defmethod string? ((thing cl:string)) t)
