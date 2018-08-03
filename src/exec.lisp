(in-package :lun)

(cffi:defcvar *errno* :int)
(cffi:defcfun ("execvp" %execvp) :int (file :pointer) (argv :pointer))
(cffi:defcfun ("strerror" %strerror) :string (errno :int))

(defun exec (file args)
  (cffi:with-foreign-string (command file)
      (let ((argc (1+ (length args))))
        (cffi:with-foreign-object (argv :string (1+ argc))
          (loop for i from 1
                for arg in args
                do (setf (cffi:mem-aref argv :string i) arg))
          (setf (cffi:mem-aref argv :string 0) command)
          (setf (cffi:mem-aref argv :string argc) (cffi:null-pointer))
          (when (minusp (%execvp command argv))
            (case *errno*
              (2 (format t "~A: command not found~%" file))
              (otherwise (uiop:println (%strerror *errno*))))
            (uiop:quit *errno*))))))