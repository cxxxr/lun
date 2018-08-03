(in-package :lun)

(defstruct option
  (forms '()))

(defun process-command-line-arguments (arguments)
  (let ((option (make-option)))
    (loop
      :for arg := (pop arguments)
      :do (cond ((member arg '("-e" "--eval") :test #'string=)
                 (push-end (list :eval (pop arguments)) (option-forms option)))
                ((member arg '("-l" "--load") :test #'string=)
                 (push-end (list :load (pop arguments)) (option-forms option)))
                ((member arg '("-s" "--system") :test #'string=)
                 (push-end (list :system (pop arguments)) (option-forms option)))
                ((member arg '("--install") :test #'string=)
                 ))
      :while arguments)
    option))
