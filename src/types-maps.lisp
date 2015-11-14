;;;; ***********************************************************************
;;;;
;;;; Name:          types-maps.lisp
;;;; Project:       the clio language
;;;; Purpose:       implementations of the maps protocol
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; ---------------------------------------------------------------------
;;; implementation: fset:map
;;; ---------------------------------------------------------------------

(defmethod make ((type (eql 'map)) &rest initargs
                 &key (contents nil)
                   &allow-other-keys)
  (let ((alist (loop for tail on contents by #'cddr
                  collect (cons (car tail)
                                (cadr tail)))))
    (fset:convert 'map alist)))

(defmethod binary-merge ((map1 map)(map2 map))
  (fset:map-union map1 map2))

(defmethod get ((map map) key &key (default nil) &allow-other-keys)
  (multiple-value-bind (found found?)(fset:@ map key)
    (if found?
        found
        default)))

(defmethod keys ((map map))
  (fset:domain map))

(defmethod merge ((map1 map) (map2 map) &rest more-maps)
  (cl:reduce #'binary-merge
             (cons map2 more-maps)
             :initial-value map1))

(defmethod pairs ((map map))
  (fset:convert 'list map))

(defmethod put ((map map) key value)
  (fset:with map key value))

(defmethod select ((map map) keys)
  (fset:restrict map (fset:convert 'fset:set keys)))

(defmethod unzip ((map map))
  (values (fset:domain map)
          (fset:range map)))

(defmethod vals ((map map))
  (fset:range map))

(defmethod zip ((key-list list) (value-list list)
                &key
                  (result-type 'map)
                  &allow-other-keys)
  (fset:convert 'map
                (mapcar (lambda (k v)(cons k v))
                        key-list
                        value-list)))

;;; ---------------------------------------------------------------------
;;; implementation: lisp sequences as maps from indexes to values
;;; ---------------------------------------------------------------------

(defmethod binary-merge ((map1 cl:sequence)(map2 cl:sequence))
  )

(defmethod get ((map cl:sequence) (key integer) &key (default nil) &allow-other-keys)
  (cl:elt map key))

(defmethod keys ((map cl:sequence))
  (loop for i from 0 below (cl:length map)
     collect i))

(defmethod merge ((map1 cl:sequence) (map2 cl:sequence) &rest more-maps)
  )

(defmethod pairs ((map cl:sequence))
  (let ((indexes (keys map)))
    (cl:map 'list
            (lambda (k v) (cons k v))
            indexes
            map)))

(defmethod put ((map cl:sequence) key value)
  )

(defmethod select ((map cl:sequence) keys)
  (let* ((vals (cl:map 'list
                       (lambda (k)(get map k))
                       keys))
         (pairs (cl:map 'list
                        (lambda (k v)(cons k v))
                        keys
                        vals)))
    (fset:convert 'map pairs)))

(defmethod unzip ((map cl:sequence))
  (let ((indexes (keys map)))
    (values indexes map)))

(defmethod vals ((map cl:sequence))
  map)

