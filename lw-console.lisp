(in-package :cl-user)

(load-all-patches)

(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(let ((standard-output *standard-output*)
      (error-output *error-output*))
  (setf *standard-output* (make-broadcast-stream)
        *error-output* (make-broadcast-stream))
  (defun main ()
    (setf *standard-output* standard-output
          *error-output* error-output)
    (loop :for arg :in (rest sys:*line-arguments-list*)
          :for form := (read-from-string arg)
          :do (eval form))
    (lw:quit)))

(pushnew '("Launcher" (:priority 60000000 :restart-action :continue) main)
         mp:*initial-processes*)

(save-image "~/.lun/lw-console"
            :console t
            :multiprocessing t
            :environment nil)
