;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-time.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on time data
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

#|
;; variables

*clock*
*default-timezone*
*default-timezone*
+asctime-format+
+day-names+
+days-per-week+
+gmt-zone+
+hours-per-day+
+iso-8601-date-format+
+iso-8601-format+
+iso-8601-time-format+
+iso-week-date-format+
+minutes-per-day+
+minutes-per-hour+
+month-names+
+months-per-year+
+rfc-1123-format+
+rfc3339-format+
+rfc3339-format/date-only+
+seconds-per-day+
+seconds-per-hour+
+seconds-per-minute+
+short-day-names+
+short-month-names+
+utc-zone+

;; types and classes

date
time-of-day
timestamp

;; functions

astronomical-julian-date
clock-now
clock-today
days-in-month
decode-timestamp
enable-read-macros
encode-timestamp
find-timezone-by-location-name
format-rfc1123-timestring
format-rfc3339-timestring
format-timestring
modified-julian-date
now
parse-rfc3339-timestring
parse-timestring
reread-timezone-repository
timestamp+
timestamp-
timestamp-century
timestamp-day
timestamp-day-of-week
timestamp-decade
timestamp-difference
timestamp-hour
timestamp-maximize-part
timestamp-maximum
timestamp-microsecond
timestamp-millennium
timestamp-millisecond
timestamp-minimize-part
timestamp-minimum
timestamp-minute
timestamp-month
timestamp-second
timestamp-subtimezone
timestamp-to-universal
timestamp-to-unix
timestamp-whole-year-difference
timestamp-year
timestamp/=
timestamp<
timestamp<=
timestamp=
timestamp>
timestamp>=
to-rfc1123-timestring
to-rfc3339-timestring
today
universal-to-timestamp
unix-to-timestamp

;; macros

adjust-timestamp
adjust-timestamp!
define-timezone
make-timestamp
with-decoded-timestamp

|#
