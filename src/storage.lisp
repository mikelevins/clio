;;;; ***********************************************************************
;;;;
;;;; Name:          storage.lisp
;;;; Project:       Clio
;;;; Purpose:       primitive code for reading and writing SQLite files
;;;; Author:        mikel evins
;;;; Copyright:     2018 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

;;; GENERIC FUNCTION make-sqlite-file (path)
;;; ---------------------------------------------------------------------
;;; creates a SQLite file with user_version = 0 at the supplied path.
;;; returns the path if successful

(defmethod make-sqlite-file ((path pathname))
  (if (and path
           (file-pathname-p path))
      (with-open-database (db path)
        (execute-non-query db "pragma user_version = 0"))
      (error "Invalid pathname for creating a SQLite file: ~S"
             path)))

(defmethod make-sqlite-file ((path string))
  (make-sqlite-file (pathname path)))

;;; (make-sqlite-file "/Users/mikel/Desktop/test.sqlite")
;;; (valid-sqlite-file? "/Users/mikel/Desktop/test.sqlite")

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
           (condition (c)(declare (ignore c)) nil))
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

;;; GENERIC FUNCTION sqlite-count-table-rows (path table-name)
;;; ---------------------------------------------------------------------
;;; returns a count of rows in the named table in the file at PATH

(defmethod sqlite-count-rows ((path pathname) (table-name string))
  (sqlite:with-open-database (db path)
    (sqlite:execute-single db (format nil "select count(*) from ~A" table-name))))

(defmethod sqlite-count-rows ((path string) (table-name string))
  (sqlite-count-rows (pathname path) table-name))

;;; (sqlite-count-rows "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents")

;;; GENERIC FUNCTION sqlite-get-rows (path table-name &key (from 0) (count nil)))
;;; ---------------------------------------------------------------------
;;; returns a list of rows from the named table in the file at
;;; PATH. Collects COUNT rows starting at index FROM. If COUNT is NIL,
;;; returns all rows.

(defmethod sqlite-get-rows ((path pathname) (table-name string) &key (from 0) (count nil))
  (sqlite:with-open-database (db path)
    (let ((count (or count
                     (sqlite-count-rows path table-name))))
      (sqlite:execute-to-list db (format nil "select * from ~a limit ~d,~d" table-name from count)))))

(defmethod sqlite-get-rows ((path string) (table-name string) &key (from 0) (count nil))
  (sqlite-get-rows (pathname path) table-name :from from :count count))

;;; (sqlite-get-rows "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents" :from 0 :count 10)
;;; (sqlite-get-rows "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents" :from 100 :count 10)

;;; GENERIC FUNCTION sqlite-get-row (path table-name index))
;;; ---------------------------------------------------------------------
;;; returns the row at INDEX from the table named TABLE-NAME in the
;;; file at PATH.

(defmethod sqlite-get-row ((path pathname) (table-name string) (index integer))
  (sqlite:with-open-database (db path)
    (sqlite:execute-to-list db (format nil "select * from ~a limit ~d,~d" table-name index 1))))

(defmethod sqlite-get-row ((path string) (table-name string) (index integer))
  (sqlite-get-row (pathname path) table-name index))

;;; (sqlite-get-row "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents" 0)
;;; (sqlite-get-row "/Users/mikel/Workshop/src/delectus/test-data/Movies.delectus2" "contents" 100)


