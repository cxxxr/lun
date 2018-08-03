(in-package :lun)

(defun run (option)
  (let* ((implementation (make-instance 'lispworks))
         (executable (find-lisp implementation)))
    (execute implementation executable option)))

(defun main ()
  (let ((option (process-command-line-arguments (rest sys:*line-arguments-list*))))
    (run option))
  (lw:quit :status 0))
