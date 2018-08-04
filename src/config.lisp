(in-package :lun)

(defun read-config-form ()
  (ignore-errors
   (let ((*read-eval* nil))
     (uiop:read-file-form +config-pathname+))))

(defun read-config (key &optional default)
  (let ((plist (read-config-form)))
    (if plist
        (getf plist key default)
        default)))
