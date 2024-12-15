;;; initialization code for building the clio executable

#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(require :asdf)
(asdf:initialize-source-registry
 '(:source-registry
   (:tree (:home "lisp"))
   (:tree (:home "Triton/repos/"))
   :inherit-configuration))
