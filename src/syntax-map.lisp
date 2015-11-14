;;;; ***********************************************************************
;;;;
;;;; Name:          syntax-map.lisp
;;;; Project:       the clio language
;;;; Purpose:       finite maps 
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :cl)

(set-syntax-from-char #\{ #\()
(set-syntax-from-char #\} #\))

(set-macro-character #\{
                     (lambda (stream char)
                       (declare (ignore char))
                       (let ((elts (read-delimited-list #\} stream t)))
                         `(clio:make 'clio:map :contents (list ,@elts)))))


(in-package :fset)

;;; change to a less visually-cluttered printing style for wb-maps

(defun print-wb-map (map stream level)
  (declare (ignore level))
  (pprint-logical-block (stream nil :prefix "{")
    (do-map (x y map)
      (pprint-pop)
      (write-char #\Space stream)
      (pprint-newline :linear stream)
      (write x :stream stream)
      (write-char #\Space stream)
      (write y :stream stream))
    (format stream " }~:[~;/~:*~S~]" (map-default map))))

