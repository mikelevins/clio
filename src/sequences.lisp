;;;; ***********************************************************************
;;;;
;;;; Name:          sequences.lisp
;;;; Project:       the clio language
;;;; Purpose:       clio sequence api
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio)

;;; ---------------------------------------------------------------------
;;; conversions: as
;;; ---------------------------------------------------------------------

(defmethod as ((type (cl:eql 'list))(sequence null) &key &allow-other-keys)
  sequence)

(defmethod as ((type (cl:eql 'list))(sequence cl:cons) &key &allow-other-keys)
  sequence)

(defmethod as ((type (cl:eql 'list))(sequence vector) &key &allow-other-keys)
  (cl:coerce sequence 'list))

(defmethod as ((type (cl:eql 'list))(sequence string) &key &allow-other-keys)
  (cl:coerce sequence 'list))

(defmethod as ((type (cl:eql 'list))(sequence seq) &key &allow-other-keys)
  (fset:convert 'list sequence))


(defmethod as ((type (cl:eql 'vector))(sequence null) &key &allow-other-keys)(vector))

(defmethod as ((type (cl:eql 'vector))(sequence cl:cons) &key &allow-other-keys)
  (cl:coerce sequence 'vector))

(defmethod as ((type (cl:eql 'vector))(sequence vector) &key &allow-other-keys)
  sequence)

(defmethod as ((type (cl:eql 'vector))(sequence string) &key &allow-other-keys)
  sequence)

(defmethod as ((type (cl:eql 'vector))(sequence seq) &key &allow-other-keys)
  (fset:convert 'vector sequence))


(defmethod as ((type (cl:eql 'string))(sequence null) &key &allow-other-keys)
  "")

(defmethod as ((type (cl:eql 'string))(sequence cl:cons) &key &allow-other-keys)
  (if (cl:every 'cl:characterp sequence)
      (cl:coerce sequence 'string)
      (error "Some elements are not characters: ~S" sequence)))

(defmethod as ((type (cl:eql 'string))(sequence vector) &key &allow-other-keys)
  (if (cl:every 'cl:characterp sequence)
      (cl:coerce sequence 'string)
      (error "Some elements are not characters: ~S" sequence)))

(defmethod as ((type (cl:eql 'string))(sequence string) &key &allow-other-keys)
  sequence)

(defmethod as ((type (cl:eql 'string))(sequence seq) &key &allow-other-keys)
  (if (fset::every 'cl:characterp sequence)
      (fset:convert 'string sequence)
      (error "Some elements are not characters: ~S" sequence)))


(defmethod as ((type (cl:eql 'seq))(sequence null) &key &allow-other-keys)
  (fset:convert 'fset:seq sequence))

(defmethod as ((type (cl:eql 'seq))(sequence cl:cons) &key &allow-other-keys)
  (fset:convert 'fset:seq sequence))

(defmethod as ((type (cl:eql 'seq))(sequence vector) &key &allow-other-keys)
  (fset:convert 'fset:seq sequence))

(defmethod as ((type (cl:eql 'seq))(sequence string) &key &allow-other-keys)
  (fset:convert 'fset:seq sequence))

(defmethod as ((type (cl:eql 'seq))(sequence seq) &key &allow-other-keys)
  sequence)

;;; ---------------------------------------------------------------------
;;; constructor: make
;;; ---------------------------------------------------------------------

(defmethod make ((type (cl:eql 'null)) &key &allow-other-keys)
  nil)

(defmethod make ((type (cl:eql 'list))
                 &key
                   (length 0 length?)
                   (initial-contents nil initial-contents?)
                   (initial-element nil initial-element?)
                   &allow-other-keys)
  (if initial-contents?
      (if initial-element?
          (error "Can't specify both initial-contents and initial-element")
          (if length?
              (if (= length (cl:length initial-contents))
                  (cl:copy-tree initial-contents)
                  (error "length must equal the length of initial-contents"))
              (cl:copy-tree initial-contents)))
      (cl:make-list length :initial-element initial-element)))

(defmethod make ((type (cl:eql 'vector))
                 &key
                   (length 0 length?)
                   (initial-contents nil initial-contents?)
                   (initial-element nil initial-element?)
                   &allow-other-keys)
  (if initial-contents?
      (if initial-element?
          (error "Can't specify both initial-contents and initial-element")
          (if length?
              (if (= length (cl:length initial-contents))
                  (cl:coerce initial-contents 'cl:vector)
                  (error "length must equal the length of initial-contents"))
              (cl:coerce initial-contents 'cl:vector)))
      (cl:make-array length :initial-element initial-element)))

(defmethod make ((type (cl:eql 'string))
                 &key
                   (length 0 length?)
                   (initial-contents nil initial-contents?)
                   (initial-element nil initial-element?)
                   &allow-other-keys)
  (if initial-contents?
      (if initial-element?
          (error "Can't specify both initial-contents and initial-element")
          (if (cl:every #'cl:characterp initial-contents)
              (if length?
                  (if (= length (cl:length initial-contents))
                      (cl:coerce initial-contents 'cl:string)
                      (error "length must equal the length of initial-contents"))
                  (cl:coerce initial-contents 'cl:string))
              (error "Found non-character input in ~S" (cl:remove-if #'cl:characterp initial-contents))))
      (cl:make-string length :initial-element (or initial-element #\.))))

(defmethod make ((type (cl:eql 'seq))
                 &key
                   (length 0 length?)
                   (initial-contents nil initial-contents?)
                   (initial-element nil initial-element?)
                   &allow-other-keys)
  (if initial-contents?
      (if initial-element?
          (error "Can't specify both initial-contents and initial-element")
          (if length?
              (if (= length (cl:length initial-contents))
                  (fset:convert 'seq initial-contents)
                  (error "length must equal the length of initial-contents"))
              (fset:convert 'seq initial-contents)))
      (fset:convert 'seq (cl:make-array length :initial-element initial-element))))

;;; ---------------------------------------------------------------------
;;; sequence functions
;;; ---------------------------------------------------------------------

;;; function add-first
;;;
;;; (add-first x sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod add-first (x (sequence cl:null))
  (cl:list x))

(defmethod add-first (x (sequence cl:cons))
  (cl:cons x sequence))

(defmethod add-first (x (sequence cl:vector))
  (cl:concatenate 'cl:vector (cl:vector x) sequence))

(defmethod add-first ((x cl:character) (sequence cl:string))
  (cl:concatenate 'cl:string (cl:string x) sequence))

(defmethod add-first (x (sequence seq))
  (fset:with-first sequence x))

;;; function add-last 
;;;
;;; (add-last sequence x) => sequence'
;;; ---------------------------------------------------------------------

(defmethod add-last ((sequence cl:null) x)
  (cl:list x))

(defmethod add-last ((sequence cl:cons) x)
  (cl:append sequence (cl:list x)))

(defmethod add-last ((sequence cl:vector) x)
  (cl:concatenate 'cl:vector sequence (vector x)))

(defmethod add-last ((sequence cl:string) (x cl:character))
  (cl:concatenate 'cl:string sequence (string x)))

(defmethod add-last ((sequence seq) x)
  (fset:with-last sequence x))

;;; function any
;;;
;;; (any sequence) => anything
;;; ---------------------------------------------------------------------

(cl:defparameter *any-random-state* (cl:make-random-state))

(defmethod any ((sequence cl:null))
  nil)

(defmethod any ((sequence cl:sequence))
  (cl:elt sequence (cl:random (cl:length sequence) *any-random-state*)))

(defmethod any ((sequence seq))
  (fset:@ sequence (cl:random (fset:size sequence) *any-random-state*)))

;;; function append 
;;;
;;; (append &rest sequences) => sequence
;;; ---------------------------------------------------------------------

(cl:defun append (&rest sequences)
  (cl:reduce 'binary-append sequences))

;;; function binary-append 
;;;
;;; (binary-append sequence1 sequence2) => sequence3
;;; ---------------------------------------------------------------------

(defmethod binary-append ((sequence1 cl:null) (sequence2 cl:null)) nil)
(defmethod binary-append ((sequence1 cl:null) (sequence2 cl:cons)) sequence2)
(defmethod binary-append ((sequence1 cl:null) (sequence2 cl:vector)) (cl:coerce sequence2 'cl:list))
(defmethod binary-append ((sequence1 cl:null) (sequence2 seq)) (as 'cl:list sequence2))

(defmethod binary-append ((sequence1 cl:cons) (sequence2 cl:null)) sequence1)
(defmethod binary-append ((sequence1 cl:cons) (sequence2 cl:cons)) (cl:append sequence1 sequence2))
(defmethod binary-append ((sequence1 cl:cons) (sequence2 cl:vector)) (cl:concatenate 'cl:list sequence1 sequence2))
(defmethod binary-append ((sequence1 cl:cons) (sequence2 seq)) (cl:append sequence1 (as 'cl:list sequence2)))

(defmethod binary-append ((sequence1 cl:vector) (sequence2 cl:null)) sequence1)
(defmethod binary-append ((sequence1 cl:vector) (sequence2 cl:cons))(cl:concatenate 'cl:vector sequence1 sequence2))
(defmethod binary-append ((sequence1 cl:vector) (sequence2 cl:vector))(cl:concatenate 'cl:vector sequence1 sequence2))
(defmethod binary-append ((sequence1 cl:vector) (sequence2 seq))
  (cl:concatenate 'cl:vector sequence1 (as 'cl:vector sequence2)))

(defmethod binary-append ((sequence1 cl:string) (sequence2 cl:null)) sequence1)
(defmethod binary-append ((sequence1 cl:string) (sequence2 cl:sequence))
  (if (cl:every 'cl:characterp sequence2)
      (cl:concatenate 'cl:string sequence1 sequence2)
      (cl:concatenate 'cl:vector sequence1 sequence2)))
(defmethod binary-append ((sequence1 cl:string) (sequence2 seq))
  (binary-append sequence1 (as 'cl:vector sequence2)))

(defmethod binary-append ((sequence1 seq) (sequence2 cl:null)) sequence1)
(defmethod binary-append ((sequence1 seq) (sequence2 cl:cons)) (fset:concat sequence1 sequence2))
(defmethod binary-append ((sequence1 seq) (sequence2 cl:vector)) (fset:concat sequence1 sequence2))
(defmethod binary-append ((sequence1 seq) (sequence2 seq)) (fset:concat sequence1 sequence2))

;;; function by
;;;
;;; (by n sequence) => sequences
;;; ---------------------------------------------------------------------

(defmethod by ((n integer)(sequence cl:null)) nil)

(defmethod by ((n integer)(sequence cl:cons)) 
  (if (cl:nthcdr (1- n) sequence)
      (cl:cons (take n sequence)
               (by n (drop n sequence)))
      (list sequence)))

(defmethod by ((n integer)(sequence cl:vector)) 
  (if (< n (cl:length sequence))
      (cl:concatenate 'cl:vector
                   (vector (take n sequence))
                   (by n (drop n sequence)))
      (vector sequence)))

(defmethod by ((n integer)(sequence cl:string)) 
  (if (< n (cl:length sequence))
      (cl:concatenate 'cl:vector
                   (vector (take n sequence))
                   (by n (drop n sequence)))
      (vector sequence)))

(defmethod by ((n integer)(sequence seq)) 
  (if (< n (fset:size sequence))
      (fset:concat (fset:seq (take n sequence))
                   (by n (drop n sequence)))
      (fset:seq sequence)))

;;; function drop
;;;
;;; (drop n sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod drop ((n (cl:eql 0))(sequence cl:null)) nil)
(defmethod drop ((n integer)(sequence cl:null)) (error "Can't drop ~s items from NIL" n))
(defmethod drop ((n integer)(sequence cl:sequence))(cl:subseq sequence n))
(defmethod drop ((n integer)(sequence seq))(fset:subseq sequence n))

;;; function drop-while
;;;
;;; (drop-while predicate sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod drop-while (predicate (sequence cl:null))(cl:declare (cl:ignore predicate sequence)) nil)
(defmethod drop-while (predicate (sequence cl:sequence))
  (let ((pos (cl:position-if (cl:complement predicate) sequence)))
    (if pos
        (drop pos sequence)
        (drop (cl:length sequence) sequence))))

(defmethod drop-while (predicate (sequence seq))
  (let ((pos (fset:position-if (cl:complement predicate) sequence)))
    (if pos
        (drop pos sequence)
        (drop (fset:size sequence) sequence))))

;;; function element
;;;
;;; (element sequence n) => anything
;;; ---------------------------------------------------------------------

(defmethod element ((sequence cl:null)(n integer)) (error "index out of range: ~S" n))

(defmethod element ((sequence cl:sequence)(n integer))
  (elt sequence n))

(defmethod element ((sequence seq)(n integer)) 
  (cl:multiple-value-bind (val found?)(fset:@ sequence n)
    (if found? val (error "Index out of range: ~S" n))))

;;; function empty?
;;;
;;; (empty? sequence) => Boolean
;;; ---------------------------------------------------------------------

(defmethod empty? ((sequence cl:null)) t)
(defmethod empty? ((sequence cl:sequence))(cl:zerop (cl:length sequence)))
(defmethod empty? ((sequence seq))(cl:zerop (fset:size sequence)))

;;; function every? 
;;;
;;; (every? predicate sequence &rest sequences) => Generalized Boolean
;;; ---------------------------------------------------------------------

(cl:defun every? (predicate sequence &rest sequences)
  (cl:apply 'fset::every predicate sequence sequences))

;;; function filter
;;;
;;; (filter x sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod filter (predicate (sequence cl:null)) 
  (cl:declare (cl:ignore predicate))
  nil)

(defmethod filter (predicate (sequence cl:sequence))
  (cl:remove-if (cl:complement predicate) sequence))

(defmethod filter (predicate (sequence seq))
  (fset:remove-if (cl:complement predicate) sequence))

;;; function find-if 
;;;
;;; (find-if predicate sequence &key start end key) => anything
;;; ---------------------------------------------------------------------

(defmethod find-if (predicate (sequence cl:null) &key (start 0) end (key 'cl:identity)) 
  (cl:declare (cl:ignore predicate start end key))
  nil)

(defmethod find-if (predicate (sequence cl:sequence) &key (start 0) end (key 'cl:identity))
  (cl:find-if predicate sequence :start start :end end :key key))

(defmethod find-if (predicate (sequence seq) &key (start 0) end (key 'cl:identity))
  (let ((sequence (fset:subseq sequence start end)))
    (fset:find-if predicate sequence :key key)))

;;; function first
;;;
;;; (first sequence) => anything
;;; ---------------------------------------------------------------------

(defmethod first ((sequence cl:null))
  nil)

(defmethod first ((sequence cl:cons))
  (cl:first sequence))

(defmethod first ((sequence cl:sequence))
  (cl:elt sequence 0))

(defmethod first ((sequence seq))
  (fset:@ sequence 0))

;;; function interleave
;;;
;;; (interleave sequence1 sequence2) => sequence3
;;; ---------------------------------------------------------------------

;;; null
(defmethod interleave ((sequence1 cl:null)(sequence2 cl:null)) nil)
(defmethod interleave ((sequence1 cl:null)(sequence2 cl:cons)) nil)
(defmethod interleave ((sequence1 cl:null)(sequence2 cl:vector)) nil)
(defmethod interleave ((sequence1 cl:null)(sequence2 seq)) nil)

;;; cons
(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:null)) nil)

(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:cons)) 
  (cl:loop for x in sequence1 for y in sequence2 append (list x y)))

(defmethod interleave ((sequence1 cl:cons)(sequence2 cl:vector)) 
  (cl:loop for x in sequence1 for y across sequence2 append (list x y)))

(defmethod interleave ((sequence1 cl:cons)(sequence2 seq)) 
  (interleave sequence1 (as 'cl:list sequence2)))

;;; vector
(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:null)) (cl:vector))

(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:cons)) 
  (interleave sequence1 (as 'cl:vector sequence2)))

(defmethod interleave ((sequence1 cl:vector)(sequence2 cl:vector)) 
  (cl:coerce (cl:loop for x across sequence1 for y across sequence2 append (list x y))
             'cl:vector))

(defmethod interleave ((sequence1 cl:string)(sequence2 cl:string)) 
  (cl:coerce (cl:loop for x across sequence1 for y across sequence2 append (list x y))
             'cl:string))

(defmethod interleave ((sequence1 cl:vector)(sequence2 seq)) 
  (interleave sequence1 (as 'cl:vector sequence2)))

;;; seq
(defmethod interleave ((sequence1 seq)(sequence2 cl:null))(fset:seq))

(defmethod interleave ((sequence1 seq)(sequence2 cl:cons))
  (interleave sequence1 (as 'seq sequence2)))

(defmethod interleave ((sequence1 seq)(sequence2 cl:vector))
  (interleave sequence1 (as 'seq sequence2)))

(defmethod interleave ((sequence1 seq)(sequence2 seq)) 
  (as 'seq
      (interleave (as 'cl:vector sequence1)
                  (as 'cl:vector sequence2))))

;;; function interpose
;;;
;;; (interpose item sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod interpose (item (sequence cl:null))
  (cl:declare (cl:ignore item sequence))
  nil)

(defmethod interpose (item (sequence cl:cons)) 
  (if (null (cl:cdr sequence))
      sequence
      (cl:cons (cl:car sequence)
               (cl:cons item
                        (interpose item (cl:cdr sequence))))))

(defmethod interpose (item (sequence cl:vector)) 
  (let ((len (cl:length sequence)))
    (case len
      ((0 1) sequence)
      (t (let ((result (make-array (1- (* 2 len)) :initial-element item)))
           (cl:loop for i from 0 below len 
                    do (setf (elt result (* i 2))
                             (elt sequence i)))
           result)))))

(defmethod interpose (item (sequence seq)) 
  (let ((len (fset:size sequence)))
    (case len
      ((0 1) sequence)
      (t (let ((result-len (1- (* 2 len))))
           (fset:convert 'fset:seq
                         (cl:loop for i from 0 below result-len 
                                  collect (if (zerop (mod i 2))
                                              (fset:@ sequence (/ i 2))
                                              item))))))))


;;; function join 
;;;
;;; (join cupola sequences) => sequence
;;; ---------------------------------------------------------------------

(cl:defun join (cupola sequences)
  (apply 'append (interpose cupola sequences)))

;;; function last  
;;;
;;; (last sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod last ((sequence cl:null)) 
  (error "NIL has no elements"))

(defmethod last ((sequence cl:cons)) 
  (cl:car (cl:last sequence)))

(defmethod last ((sequence cl:vector)) 
  (let ((len (cl:length sequence)))
    (if (> len 0)
        (elt sequence (1- len))
        (error "~S has no elements" sequence))))

(defmethod last ((sequence seq)) 
  (cl:multiple-value-bind (val found?)(fset:@ sequence (1- (fset:size sequence)))
    (if found? val (error "~S has no elements" sequence))))

;;; function leave  
;;;
;;; (leave n sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod leave ((n integer)(sequence cl:null)) 
  (cond
    ((< n 0)(error "Can't leave fewer than 0 elements"))
    ((= n 0) nil)
    (t (error "NIL has fewer than ~s elements" n))))

(defmethod leave ((n integer)(sequence cl:sequence)) 
  (let ((len (cl:length sequence)))
    (cond
      ((< n 0)(error "Can't leave fewer than 0 elements"))
      ((<= n len)(cl:subseq sequence (- len n) len))
      (t (error "Sequence has fewer than ~s elements" n)))))

(defmethod leave ((n integer)(sequence seq)) 
  (let ((len (fset:size sequence)))
    (cond
      ((< n 0)(error "Can't leave fewer than 0 elements"))
      ((<= n len)(fset:subseq sequence (- len n) len))
      (t (error "Sequence has fewer than ~s elements" n)))))

;;; function length  
;;;
;;; (length sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod length ((sequence cl:null)) 0)

(defmethod length ((sequence cl:sequence)) 
  (cl:length sequence))

(defmethod length ((sequence seq)) 
  (fset:size sequence))

;;; function mismatch  
;;;
;;; (mismatch sequence1 sequence2 &key test key start1 start2 end1 end2) => position
;;; ---------------------------------------------------------------------

(defmethod mismatch ((sequence1 cl:null)(sequence2 cl:null) &key test key start1 start2 end1 end2) 
  (cl:declare (cl:ignore sequence1 sequence2 test key start1 start2 end1 end2))
  nil)

(defmethod mismatch ((sequence1 cl:sequence)(sequence2 cl:sequence) &key (test 'cl:eql) (key 'cl:identity) (start1 0) (start2 0) end1 end2) 
  (cl:mismatch sequence1 sequence2 :test test :key key :start1 start1 :start2 start2 :end1 end1 :end2 end2))

(defmethod mismatch ((sequence1 cl:sequence)(sequence2 seq) &key (test 'cl:eql) (key 'cl:identity) (start1 0) (start2 0) end1 end2) 
  (mismatch sequence1 (as 'cl:vector sequence2) :test test :key key :start1 start1 :start2 start2 :end1 end1 :end2 end2))

(defmethod mismatch ((sequence1 seq)(sequence2 cl:sequence) &key (test 'cl:eql) (key 'cl:identity) (start1 0) (start2 0) end1 end2) 
  (mismatch (as 'cl:vector sequence1) sequence2 :test test :key key :start1 start1 :start2 start2 :end1 end1 :end2 end2))

(defmethod mismatch ((sequence1 seq)(sequence2 seq) &key (test 'cl:eql) (key 'cl:identity) (start1 0) (start2 0) end1 end2) 
  (mismatch (as 'cl:vector sequence1)(as 'cl:vector sequence2) :test test :key key :start1 start1 :start2 start2 :end1 end1 :end2 end2))

;;; function partition 
;;;
;;; (partition predicate sequence1) => sequence2, sequence3
;;; ---------------------------------------------------------------------

(defmethod partition (predicate (sequence cl:null)) 
  (cl:declare (cl:ignore predicate sequence))
  (values nil nil))

(defmethod partition (predicate (sequence cl:sequence))
  (values (cl:remove-if (cl:complement predicate) sequence)
          (cl:remove-if predicate sequence)))

(defmethod partition (predicate (sequence seq)) 
  (fset:partition predicate sequence))

;;; function position 
;;;
;;; (position item sequence &key test start end key) => anything
;;; ---------------------------------------------------------------------

(defmethod position (item (sequence cl:null) &key (test 'eql) (start 0) end (key 'cl:identity)) 
  (cl:declare (cl:ignore item sequence test start end key))
  nil)

(defmethod position (item (sequence cl:sequence) &key (test 'eql) (start 0) end (key 'cl:identity))
  (cl:position item sequence :test test :start start :end end :key key))

(defmethod position (item (sequence seq) &key (test 'eql) (start 0) end (key 'cl:identity))
  (let ((sequence (fset:subseq sequence start end)))
    (fset:position item sequence :key key :test test)))

;;; function position-if 
;;;
;;; (position-if predicate sequence &key start end key) => anything
;;; ---------------------------------------------------------------------

(defmethod position-if (predicate (sequence cl:null) &key (start 0) end (key 'cl:identity)) 
  (cl:declare (cl:ignore predicate sequence start end key))
  nil)

(defmethod position-if (predicate (sequence cl:sequence) &key (start 0) end (key 'cl:identity))
  (cl:position-if predicate sequence :start start :end end :key key))

(defmethod position-if (predicate (sequence seq) &key (start 0) end (key 'cl:identity))
  (let ((sequence (fset:subseq sequence start end)))
    (fset:position-if predicate sequence :key key)))

;;; function prefix-match?
;;;
;;; (prefix-match? prefix sequence &key test key) => Generalized Boolean
;;; ---------------------------------------------------------------------

(cl:defun %general-prefix-match (prefix sequence &key (test 'cl:equal) (key 'cl:identity))
  (or (empty? prefix)
      (and (<= (length prefix)
               (length sequence))
           (cl:block searching
             (cl:progn
               (cl:loop for i from 0 below (length prefix)
                        do (unless (funcall test
                                            (funcall key (element prefix i))
                                            (funcall key (element sequence i)))
                             (return-from searching nil)))
               t)))))

(defmethod prefix-match? (prefix sequence &key test key) 
  (cl:declare (cl:ignore prefix sequence test key))
  nil)

(defmethod prefix-match? ((prefix cl:null)(sequence cl:null) &key test key)(cl:declare (cl:ignore prefix sequence test key)) t)
(defmethod prefix-match? ((prefix cl:null)(sequence cl:sequence) &key test key)(cl:declare (cl:ignore prefix sequence test key)) t)
(defmethod prefix-match? ((prefix cl:null)(sequence seq) &key test key)(cl:declare (cl:ignore prefix sequence test key)) t)

(defmethod prefix-match? ((prefix cl:sequence)(sequence cl:null) &key test key)
  (cl:declare (cl:ignore test key))
  (empty? prefix))

(defmethod prefix-match? ((prefix cl:sequence)(sequence cl:sequence) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-prefix-match prefix sequence :test test :key key))

(defmethod prefix-match? ((prefix cl:sequence)(sequence seq) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-prefix-match prefix sequence :test test :key key))

(defmethod prefix-match? ((prefix seq)(sequence cl:null) &key test key)
  (cl:declare (cl:ignore test key))
  (empty? prefix))

(defmethod prefix-match? ((prefix seq)(sequence cl:sequence) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-prefix-match prefix sequence :test test :key key))

(defmethod prefix-match? ((prefix seq)(sequence seq) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-prefix-match prefix sequence :test test :key key))

;;; function range 
;;;
;;; (range start end &key by) => sequence
;;; ---------------------------------------------------------------------

(defmethod range ((start integer) (end integer) &key (by 1))
  (let ((step by))
    (if (cl:plusp (- end start))
        (cl:loop for i from start below end by step collect i)
        (cl:loop for i downfrom start above end by step collect i))))

;;; function reduce 
;;;
;;; (reduce fn sequence &key key initial-value) => sequence'
;;; ---------------------------------------------------------------------

(defmethod reduce (fn (sequence cl:sequence) &key (key 'cl:identity) (initial-value nil))
  (cl:reduce fn sequence :key key :initial-value initial-value))

(defmethod reduce (fn (sequence seq) &key (key 'cl:identity) (initial-value nil))
  (fset:reduce fn sequence :key key :initial-value initial-value))

;;; function remove-if
;;;
;;; (remove-if predicate sequence &key start end key) => sequence'
;;; ---------------------------------------------------------------------

(defmethod remove-if (predicate (sequence cl:null) &key (start 0) end (key 'cl:identity)) 
  (cl:declare (cl:ignore predicate start end key))
  nil)

(defmethod remove-if (predicate (sequence cl:sequence) &key (start 0) end (key 'cl:identity))
  (cl:remove-if predicate sequence :start start :end end :key key))

(defmethod remove-if (predicate (sequence seq) &key (start 0) end (key 'cl:identity))
  (let ((sequence (fset:subseq sequence start end)))
    (fset:remove-if predicate sequence :start start :end end :key key)))

;;; function remove-duplicates 
;;;
;;; (remove-duplicates sequence &key test start end key) => sequence'
;;; ---------------------------------------------------------------------

(defmethod remove-duplicates ((sequence cl:null) &key (test 'eql) (start 0) end (key 'cl:identity)) 
  (cl:declare (cl:ignore test start end key))
  nil)

(defmethod remove-duplicates ((sequence cl:sequence) &key (test 'eql) (start 0) end (key 'cl:identity)) 
  (cl:remove-duplicates sequence :test test :start start :end end :key key))

(defmethod remove-duplicates ((sequence seq) &key (test 'eql) (start 0) end (key 'cl:identity)) 
  (as 'seq (cl:remove-duplicates (as 'cl:vector sequence) :test test :start start :end end :key key)))

;;; function rest
;;;
;;; (rest sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod rest ((sequence cl:null))
  nil)

(defmethod rest ((sequence cl:sequence))
  (cl:subseq sequence 1))

(defmethod rest ((sequence seq))
  (fset:subseq sequence 1))

;;; reverse 
;;;
;;; (reverse sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod reverse ((sequence cl:null))
  nil)

(defmethod reverse ((sequence cl:sequence))
  (cl:reverse sequence))

(defmethod reverse ((sequence seq))
  (fset:reverse sequence))

;;; search  
;;;
;;; (search sequence1 sequence2 &key start1 end1 start2 end2 test key) => Generalized Boolean
;;; ---------------------------------------------------------------------

(defmethod search ((sequence1 cl:null)(sequence2 cl:null) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity))
  (cl:declare (cl:ignore sequence1 sequence2 start1 end1 start2 end2 test key))
  0)

(defmethod search ((sequence1 cl:null)(sequence2 cl:sequence) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:declare (cl:ignore sequence1 sequence2 start1 end1 start2 end2 test key))
  0)

(defmethod search ((sequence1 cl:null)(sequence2 seq) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:declare (cl:ignore sequence1 sequence2 start1 end1 start2 end2 test key))
  0)

(defmethod search ((sequence1 cl:sequence)(sequence2 cl:null) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:declare (cl:ignore sequence1 sequence2 start1 end1 start2 end2 test key))
  nil)

(defmethod search ((sequence1 cl:sequence)(sequence2 cl:sequence) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:search sequence1 sequence2 :start1 start1 :start2 start2 :end1 end1 :end2 end2 :test test :key key))

(defmethod search ((sequence1 cl:sequence)(sequence2 seq) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:search sequence1 (as 'cl:vector sequence2) :start1 start1 :start2 start2 :end1 end1 :end2 end2 :test test :key key))

(defmethod search ((sequence1 seq)(sequence2 cl:null) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity))
  (cl:declare (cl:ignore start1 start2 end1 end2 test key))
  nil)

(defmethod search ((sequence1 seq)(sequence2 cl:sequence) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:search (as 'cl:vector sequence1) sequence2 :start1 start1 :start2 start2 :end1 end1 :end2 end2 :test test :key key))

(defmethod search ((sequence1 seq)(sequence2 seq) &key (start1 0) end1 (start2 0) end2 (test 'cl:equal) (key 'cl:identity)) 
  (cl:search (as 'cl:vector sequence1) (as 'cl:vector sequence2) :start1 start1 :start2 start2 :end1 end1 :end2 end2 :test test :key key))

;;; function second 
;;;
;;; (second sequence) => anything
;;; ---------------------------------------------------------------------

(defmethod second ((sequence cl:null))
  (cl:declare (cl:ignore sequence))
  nil)

(defmethod second ((sequence cl:cons))
  (cl:second sequence))

(defmethod second ((sequence cl:sequence))
  (cl:elt sequence 1))

(defmethod second ((sequence seq))
  (fset:@ sequence 1))

;;; function seq
;;;
;;; (seq &rest elements) => seq
;;; ---------------------------------------------------------------------

(cl:defun seq (&rest elements)
  (fset:convert 'fset:seq elements))

;;; function seq?
;;;
;;; (seq? thing) => Boolean
;;; ---------------------------------------------------------------------

(defmethod seq? (thing)(cl:declare (cl:ignore thing)) nil)
(defmethod seq? ((thing seq))(cl:declare (cl:ignore thing)) t)

;;; function shuffle  
;;;
;;; (shuffle sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod shuffle ((sequence cl:null))(cl:declare (cl:ignore sequence)) nil)
(defmethod shuffle ((sequence cl:cons)) (cl:sort (copy-tree sequence) (lambda (x y)(cl:declare (cl:ignore x y))(cl:elt '(nil t)(random 2)))))

(defmethod shuffle ((sequence cl:vector)) 
  (let ((sequence* (cl:map (type-of sequence) 'cl:identity sequence)))
    (cl:sort sequence*
             (lambda (x y)
               (cl:declare (cl:ignore x y))
               (cl:elt '(nil t)(random 2))))))

(defmethod shuffle ((sequence seq))
  (fset:sort sequence
             (lambda (x y)
               (cl:declare (cl:ignore x y))
               (cl:elt '(nil t)(random 2)))))

;;; function some?  
;;;
;;; (some? predicate sequence &rest sequences) => anything
;;; ---------------------------------------------------------------------

(cl:defun some? (predicate sequence &rest sequences) 
  (let* ((sequences (cl:cons sequence sequences))
         (lens (cl:mapcar 'length sequences))
         (len (apply 'cl:min lens)))
    (cl:block searching
      (cl:loop for i from 0 below len
               do (let* ((args (cl:mapcar (lambda (s)(element s i)) sequences))
                         (result (apply predicate args)))
                    (when result (return-from searching result))
                    nil)))))

;;; function split  
;;;
;;; (split sequence sentinel &key key test) => sequence'
;;; ---------------------------------------------------------------------

;;; null
(defmethod split ((sequence cl:null)(sentinel cl:null) &key (key 'cl:identity)(test 'cl:eql))
  (cl:declare (cl:ignore key test))
  nil)

(defmethod split ((sequence cl:null)(sentinel cl:cons) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore key test))
  nil)

(defmethod split ((sequence cl:null)(sentinel cl:vector) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore key test))
  nil)

(defmethod split ((sequence cl:null)(sentinel seq) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore key test))
  nil)

;;; cons
(defmethod split ((sequence cl:cons)(sentinel cl:null) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore key test))
  (by 1 sequence))

(defmethod split ((sequence cl:cons)(sentinel cl:cons) &key (key 'cl:identity)(test 'cl:eql)) 
  (if (empty? sentinel)
      (by 1 sequence)
      (if (< (length sequence)
             (length sentinel))
          (list sequence)
          (let ((pos (search sentinel sequence :key key :test test)))
            (if pos
                (cl:cons (cl:subseq sequence 0 pos)
                         (split (cl:subseq sequence (+ pos (length sentinel)))
                                sentinel :key key :test test))
                (list sequence))))))

(defmethod split ((sequence cl:cons)(sentinel cl:vector) &key (key 'cl:identity)(test 'cl:eql)) 
  (if (empty? sentinel)
      (by 1 sequence)
      (split sequence (as 'cl:list sentinel) :key key :test test)))

(defmethod split ((sequence cl:cons)(sentinel seq) &key (key 'cl:identity)(test 'cl:eql)) 
  (if (empty? sentinel)
      (by 1 sequence)
      (split sequence (as 'cl:list sentinel) :key key :test test)))

;;; vector
(defmethod split ((sequence cl:vector)(sentinel cl:null) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore sentinel key test))
  (by 1 sequence))

(defmethod split ((sequence cl:vector)(sentinel cl:cons) &key (key 'cl:identity)(test 'cl:eql)) 
  (split sequence (as 'cl:vector sentinel) :key key :test test))

(defmethod split ((sequence cl:vector)(sentinel cl:vector) &key (key 'cl:identity)(test 'cl:eql)) 
  (if (empty? sentinel)
      (by 1 sequence)
      (if (< (length sequence)
             (length sentinel))
          (if (empty? sequence)
              (cl:vector)
              (cl:vector sequence))
          (let ((pos (search sentinel sequence :key key :test test)))
            (if pos
                (cl:concatenate 'cl:vector
                             (cl:vector (cl:subseq sequence 0 pos))
                             (split (cl:subseq sequence (+ pos (length sentinel)))
                                    sentinel :key key :test test))
                (if (empty? sequence)
                    (cl:vector)
                    (cl:vector sequence)))))))

(defmethod split ((sequence cl:vector)(sentinel seq) &key (key 'cl:identity)(test 'cl:eql)) 
  (split sequence (as 'cl:vector sentinel) :key key :test test))

;;; seq
(defmethod split ((sequence seq)(sentinel cl:null) &key (key 'cl:identity)(test 'cl:eql)) 
  (cl:declare (cl:ignore sentinel key test))
  (by 1 sequence))

(defmethod split ((sequence seq)(sentinel cl:cons) &key (key 'cl:identity)(test 'cl:eql)) 
  (split sequence (as 'seq sentinel) :key key :test test))

(defmethod split ((sequence seq)(sentinel cl:vector) &key (key 'cl:identity)(test 'cl:eql)) 
  (split sequence (as 'seq sentinel) :key key :test test))

(defmethod split ((sequence seq)(sentinel seq) &key (key 'cl:identity)(test 'cl:eql)) 
  (if (empty? sentinel)
      (by 1 sequence)
      (if (< (length sequence)
             (length sentinel))
          (if (empty? sequence)
              (seq)
              (seq sequence))
          (let ((pos (search sentinel sequence :key key :test test)))
            (if pos
                (fset:concat
                 (seq (fset:subseq sequence 0 pos))
                 (split (fset::subseq sequence (+ pos (length sentinel)))
                        sentinel :key key :test test))
                (if (empty? sequence)
                    (seq)
                    (seq sequence)))))))

;;; function subsequence 
;;;
;;; (subsequence sequence start &optional end) => sequence'
;;; ---------------------------------------------------------------------

(defmethod subsequence ((sequence cl:sequence) (start integer) &optional (end nil))
  (let ((end (or end (length sequence))))
    (cl:subseq sequence start end)))

(defmethod subsequence ((sequence seq) (start integer) &optional (end nil))
  (let ((end (or end (length sequence))))
    (fset:subseq sequence start end)))

;;; function substitute
;;;
;;; (substitute new-item old-item sequence &key key test) => sequence'
;;; ---------------------------------------------------------------------

(defmethod substitute (new-item old-item (sequence cl:sequence) &key (test 'cl:eql) (key 'cl:identity))
  (cl:substitute new-item old-item sequence :test test :key key))

(defmethod substitute (new-item old-item (sequence seq) &key (test 'cl:eql)(key 'cl:identity))
  (fset:substitute new-item old-item sequence :key key))

;;; function substitute-if
;;;
;;; (substitute-if new-item predicate sequence &key key) => sequence'
;;; ---------------------------------------------------------------------

(defmethod substitute-if (new-item predicate (sequence cl:sequence) &key (key 'cl:identity))
  (cl:substitute-if new-item predicate sequence :key key))

(defmethod substitute-if (new-item predicate (sequence seq) &key (key 'cl:identity))
  (fset:substitute-if new-item predicate sequence :key key))

;;; function suffix-match?   
;;;
;;; (suffix-match? sequence suffix &key test key) => Generalized Boolean
;;; ---------------------------------------------------------------------

(cl:defun %general-suffix-match (sequence suffix &key (test 'cl:equal) (key 'cl:identity))
  (or (empty? suffix)
      (let* ((sufflen (length suffix))
             (seqlen (length sequence))
             (suffstart (- seqlen sufflen)))
        (and (<= sufflen seqlen)
             (cl:block searching
               (cl:progn
                 (cl:loop for i from 0 below (length suffix)
                          do (unless (funcall test
                                              (funcall key (element suffix i))
                                              (funcall key (element sequence (+ suffstart i))))
                               (return-from searching nil)))
                 t))))))

(defmethod suffix-match? (sequence suffix &key test key) 
  (cl:declare (cl:ignore sequence suffix test key))
  nil)

(defmethod suffix-match? ((sequence cl:null)(suffix cl:null) &key test key)
  (cl:declare (cl:ignore sequence suffix test key))
  t)

(defmethod suffix-match? ((sequence cl:sequence)(suffix cl:null) &key test key)
  (cl:declare (cl:ignore sequence suffix test key))
  t)

(defmethod suffix-match? ((sequence seq)(suffix cl:null) &key test key)
  (cl:declare (cl:ignore sequence suffix test key))
  t)

(defmethod suffix-match? ((sequence cl:null)(suffix cl:sequence) &key test key)
  (cl:declare (cl:ignore test key))
  (empty? suffix))

(defmethod suffix-match? ((sequence cl:sequence)(suffix cl:sequence) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-suffix-match sequence suffix :test test :key key))

(defmethod suffix-match? ((sequence seq)(suffix cl:sequence) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-suffix-match sequence suffix :test test :key key))


(defmethod suffix-match? ((sequence cl:null)(suffix seq) &key test key)
  (cl:declare (cl:ignore test key))
  (empty? suffix))

(defmethod suffix-match? ((sequence cl:sequence)(suffix seq) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-suffix-match sequence suffix :test test :key key))

(defmethod suffix-match? ((sequence seq)(suffix seq) &key (test 'cl:equal) (key 'cl:identity)) 
  (%general-suffix-match sequence suffix :test test :key key))

;;; function tail
;;;
;;; (tail sequence) => anything
;;; ---------------------------------------------------------------------

(defmethod tail ((sequence cl:null))
  nil)

(defmethod tail ((sequence cl:sequence))
  (cl:subseq sequence 1))

(defmethod tail ((sequence seq))
  (fset:subseq sequence 1))

;;; function tails
;;;
;;; (tails sequence &key by) => list
;;; ---------------------------------------------------------------------

(cl:defun %general-tails-by (sequence step)
  (let ((indexes (range 0 (length sequence) :by step)))
    (cl:loop for i in indexes collect (subsequence sequence i))))

(defmethod tails ((sequence cl:null) &key by) 
  (cl:declare (cl:ignore sequence by))
  nil)

(defmethod tails ((sequence cl:cons) &key (by 1)) 
  (%general-tails-by sequence by))

(defmethod tails ((sequence cl:vector) &key (by 1)) 
  (cl:map 'vector
          (lambda (it)(cl:coerce it 'vector))
          (%general-tails-by sequence by)))

(defmethod tails ((sequence seq) &key (by 1)) 
  (fset:convert 'seq
                (cl:mapcar (lambda (it)(fset:convert 'seq it))
                           (%general-tails-by sequence by))))

;;; function take
;;;
;;; (take n sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod take ((n (cl:eql 0))(sequence cl:null)) (cl:declare (cl:ignore n sequence)) nil)
(defmethod take ((n integer)(sequence cl:null)) (error "Can't take ~s items from NIL" n))
(defmethod take ((n integer)(sequence cl:sequence))(cl:subseq sequence 0 (cl:min n (length sequence))))
(defmethod take ((n integer)(sequence seq))(fset:subseq sequence 0 (cl:min n (length sequence))))

;;; function take-by
;;;
;;; (take-by m n sequence) => sequences
;;; ---------------------------------------------------------------------

(defmethod take-by ((m (cl:eql 0))(n (cl:eql 0))(sequence cl:null)) nil)
(defmethod take-by ((m integer)(n integer)(sequence cl:null)) (error "Can't take-by ~s ~s items from NIL" m n))

(defmethod take-by ((m integer)(n integer)(sequence cl:sequence))
  (cl:mapcar (lambda (s)(take m s))
             (tails sequence :by n)))

(defmethod take-by ((m integer)(n integer)(sequence seq))
  (cl:mapcar (lambda (s)(take m s))
             (tails sequence :by n)))

;;; function take-while
;;;
;;; (take-while predicate sequence) => sequence'
;;; ---------------------------------------------------------------------

(defmethod take-while (predicate (sequence cl:null))(cl:declare (cl:ignore predicate)) nil)

(defmethod take-while (predicate (sequence cl:sequence)) 
  (let ((pos (position-if (cl:complement predicate) sequence)))
    (if pos
        (subsequence sequence 0 pos)
        sequence)))

(defmethod take-while (predicate (sequence seq)) 
  (let ((pos (position-if (cl:complement predicate) sequence)))
    (if pos
        (subsequence sequence 0 pos)
        sequence)))

;;; function zip
;;;
;;; (zip sequence1 sequence2) => sequence3
;;; ---------------------------------------------------------------------

(defmethod zip ((sequence1 cl:null) (sequence2 cl:null)) nil)
(defmethod zip ((sequence1 cl:null) (sequence2 cl:cons)) nil)
(defmethod zip ((sequence1 cl:null) (sequence2 cl:vector)) nil)
(defmethod zip ((sequence1 cl:null) (sequence2 seq)) nil)

(defmethod zip ((sequence1 cl:cons) (sequence2 cl:null)) nil)
(defmethod zip ((sequence1 cl:cons) (sequence2 cl:cons)) (cl:mapcar 'cl:cons sequence1 sequence2))

(defmethod zip ((sequence1 cl:cons) (sequence2 cl:vector)) 
  (cl:loop for x in sequence1 for y across sequence2 collect (cl:cons x y)))

(defmethod zip ((sequence1 cl:cons) (sequence2 seq)) 
  (cl:loop for x in sequence1 for y from 0 below (fset:size sequence2) 
           collect (cl:cons x (fset:@ sequence2 y))))

(defmethod zip ((sequence1 cl:vector) (sequence2 cl:null)) (vector))

(defmethod zip ((sequence1 cl:vector) (sequence2 cl:cons))
  (as 'cl:vector 
      (cl:loop for x across sequence1 for y in sequence2 collect (cl:cons x y))))

(defmethod zip ((sequence1 cl:vector) (sequence2 cl:vector))
  (as 'cl:vector 
      (cl:loop for x across sequence1 for y across sequence2 collect (cl:cons x y))))

(defmethod zip ((sequence1 cl:vector) (sequence2 seq))
  (as 'cl:vector
      (cl:loop for x across sequence1 for y from 0 below (fset:size sequence2) 
               collect (cl:cons x (fset:@ sequence2 y)))))

(defmethod zip ((sequence1 cl:string) (sequence2 cl:null)) "")

(defmethod zip ((sequence1 seq) (sequence2 cl:null)) (seq))

(defmethod zip ((sequence1 seq) (sequence2 cl:cons)) 
  (as 'seq
      (cl:loop for x from 0 below (fset:size sequence1) for y in sequence2
               collect (cl:cons (fset:@ sequence1 x) y))))

(defmethod zip ((sequence1 seq) (sequence2 cl:vector)) 
  (as 'seq
      (cl:loop for x from 0 below (fset:size sequence1) for y across sequence2
               collect (cl:cons (fset:@ sequence1 x) y))))

(defmethod zip ((sequence1 seq) (sequence2 seq)) 
  (as 'seq
      (cl:loop for x from 0 below (fset:size sequence1) for y from 0 below (fset:size sequence2)
               collect (cl:cons (fset:@ sequence1 x)
                                (fset:@ sequence2 y)))))

