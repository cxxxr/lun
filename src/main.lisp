(in-package :lun)

(defun process-command-line-arguments (arguments)
  (let ((options '()))
    (loop
      :for arg := (pop arguments)
      :do (cond ((member arg '("-e" "--eval") :test #'string=)
                 (push-end (list :eval (pop arguments)) options))
                ((member arg '("-l" "--load") :test #'string=)
                 (push-end (list :load (pop arguments)) options))
                ((member arg '("-s" "--system") :test #'string=)
                 (push-end (list :system (pop arguments)) options)))
      :while arguments)
    options))

(defun run (options)
  (let* ((implementation (make-instance 'lispworks))
         (executable (find-lisp implementation)))
    (execute implementation executable options)))

(defun main ()
  (let ((options (process-command-line-arguments (rest sys:*line-arguments-list*))))
    (run options))
  (lw:quit :status 0))
