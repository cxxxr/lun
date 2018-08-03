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

(defgeneric find-lisp (implementation))
(defgeneric execute (implementation executable options))

(defclass implementation () ())

(defclass lispworks (implementation) ())

(defun build-lw-console ()
  (ensure-directories-exist (merge-pathnames ".lun/" (user-homedir-pathname)))
  (let ((text (uiop:read-file-string (asdf:system-relative-pathname :lun "lw-console.lisp"))))
    (uiop:with-temporary-file (:stream out :pathname lw-console-file)
      (write-string text out)
      :close-stream
      (uiop:run-program (list (namestring +lispworks-binary+)
                              "-build" (namestring lw-console-file))))))

(defmethod find-lisp ((self lispworks))
  (let ((pathname (merge-pathnames ".lun/lw-console" (user-homedir-pathname))))
    (unless (uiop:file-exists-p pathname)
      (build-lw-console))
    pathname))

(defmethod execute ((self lispworks) executable options)
  (exec (namestring executable)
        (mapcar (lambda (option)
                  (destructuring-bind (op arg) option
                    (ecase op
                      (:eval arg)
                      (:load (format nil "(load ~S)" arg))
                      (:system (format nil "(ql:quickload ~S)" (string-upcase arg))))))
                options)))

(defun run (options)
  (let* ((implementation (make-instance 'lispworks))
         (executable (find-lisp implementation)))
    (execute implementation executable options)))

(defun main ()
  (let ((options (process-command-line-arguments (rest sys:*line-arguments-list*))))
    (run options))
  (lw:quit :status 0))
