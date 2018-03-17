;;;; ***********************************************************************
;;;;
;;;; Name:          storage.lisp
;;;; Project:       Clio
;;;; Purpose:       code for reading and writing SQLite files
;;;; Author:        mikel evins
;;;; Copyright:     2018 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; GENERIC FUNCTION valid-sqlite-file? (path)
;;; ---------------------------------------------------------------------
;;; returns PATH if it's a valid SQLite file; returns NIL if it isn't
;;; a valid sqlite-file database is an existing SQLite file that
;;; we can read from

(defmethod valid-sqlite-file? ((path pathname))
  (let ((path (probe-file path)))
    (and path
         (file-pathname-p path)
         (handler-case (with-open-database (db path)
                         ;; the right way to check whether a file is a SQLite file,
                         ;; according to SQLite docs:
                         (execute-non-query db "pragma schema_version"))
           (condition (c) nil))
         path)))

(defmethod valid-sqlite-file? ((path string))
  (valid-sqlite-file? (pathname path)))

;;; tests:
;;; should return the pathname because it's a valid sqlite file:
;;; (valid-sqlite-file? "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2")
;;; should return NIL because it isn't:
;;; (valid-sqlite-file? "/Users/mikel/.emacs")
;;; should return NIL because it doesn't exist:
;;; (valid-sqlite-file? "/Users/brobdingnag/.emacs")

;;; GENERIC FUNCTION sqlite-list-tables (path)
;;; ---------------------------------------------------------------------
;;; returns a list of table names from the file at PATH

(defmethod sqlite-list-tables ((path pathname))
  (sqlite:with-open-database (db path)
    (cons "sqlite_master"
          (mapcar #'car (sqlite:execute-to-list db "SELECT name FROM sqlite_master WHERE type = \"table\"")))))

(defmethod sqlite-list-tables ((path string))
  (sqlite-list-tables (pathname path)))

;;; (sqlite-list-tables "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2")


;;; GENERIC FUNCTION sqlite-column-info (path table-name)
;;; ---------------------------------------------------------------------
;;; returns a list of column descriptions from the named table in the
;;; file at PATH

(defmethod sqlite-column-info ((path pathname) (table-name string))
  (sqlite:with-open-database (db path)
    (sqlite:execute-to-list db (format nil "pragma table_info(~S)" table-name))))

(defmethod sqlite-column-info ((path string) (table-name string))
  (sqlite-column-info (pathname path) table-name))

;;; (sqlite-column-info "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents")
;;; returns NIL because there is no such table:
;;; (sqlite-column-info "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "foo")


;;; GENERIC FUNCTION sqlite-list-table-columns (path table-name)
;;; ---------------------------------------------------------------------
;;; returns a list of column names from the named table in the file at
;;; PATH

(defmethod sqlite-list-columns ((path pathname) (table-name string))
  (mapcar #'cadr (sqlite-column-info path table-name)))

(defmethod sqlite-list-columns ((path string) (table-name string))
  (sqlite-list-columns (pathname path) table-name))

;;; (sqlite-list-columns "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "sqlite_master")
;;; (sqlite-list-columns "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents")
;;; returns NIL because there is no such table:
;;; (sqlite-list-columns "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "foo")
;;; signals an error because the file is not a SQLite file:
;;; (sqlite-list-columns "/Users/mikel/.emacs" "foo")



