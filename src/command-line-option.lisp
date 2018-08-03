(in-package :lun)

(defstruct option
  (forms '())
  (install))

(defun read-arguments (option arguments)
  (loop
    :for arg := (pop arguments)
    :do (cond ((member arg '("-e" "--eval") :test #'string=)
               (push-end (list :eval (pop arguments)) (option-forms option)))
              ((member arg '("-l" "--load") :test #'string=)
               (push-end (list :load (pop arguments)) (option-forms option)))
              ((member arg '("-s" "--system") :test #'string=)
               (push-end (list :system (pop arguments)) (option-forms option))))
    :while arguments)
  arguments)

(defun read-install-arguments (option arguments)
  (declare (ignore option))
  arguments)

(defun process-command-line-arguments (arguments)
  (let ((option (make-option)))
    (when (equal "install" (first arguments))
      (setf arguments (read-install-arguments option (rest arguments))))
    (setf arguments (read-arguments option arguments))
    option))
