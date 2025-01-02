(in-package :app)

(defun system-version (system-designator)
  (let ((system (asdf:find-system system-designator nil)))
    (when (and system (slot-boundp system 'asdf:version))
      (asdf:component-version system))))

#+test (system-version :appexec)
