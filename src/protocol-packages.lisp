;;;; ***********************************************************************
;;;;
;;;; Name:          protocol-packages.lisp
;;;; Project:       the clio language
;;;; Purpose:       operations on packages
;;;; Author:        mikel evins
;;;; Copyright:     2015 by mikel evins
;;;;
;;;; ***********************************************************************

(in-package :clio-internal)

(defgeneric package? (thing))

#| exported from common-lisp

*package*
defpackage
delete-package
do-all-symbols
do-external-symbols
do-symbols
export
find-all-symbols
find-package
find-symbol
import
in-package
list-all-packages
make-package
package-name
package-nicknames
package-shadowing-symbols
package-use-list
package-used-by-list
rename-package
shadow
shadowing-import
unexport
unuse-package
use-package

|#

