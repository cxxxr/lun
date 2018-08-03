(in-package :lun)

(defun main ()
  (let ((argv sys:*line-arguments-list*))
    (format t "~S" argv)
    (lw:quit :status 0)))
