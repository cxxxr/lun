(in-package :lun)

(defparameter +lispworks-program+ #p"/usr/local/lib64/LispWorks/lispworks-7-1-0-amd64-linux")

(defclass lispworks (implementation) ())

(defun build-lw-console ()
  (ensure-directories-exist +lun-directory+)
  (let ((text (uiop:read-file-string (asdf:system-relative-pathname :lun "lw-console.lisp"))))
    (uiop:with-temporary-file (:stream out :pathname lw-console-file)
      (write-string text out)
      :close-stream
      (uiop:run-program (list (namestring +lispworks-program+)
                              "-build" (namestring lw-console-file))))))

(defmethod find-lisp ((self lispworks))
  (let ((pathname (merge-pathnames "lw-console" +lun-directory+)))
    (unless (uiop:file-exists-p pathname)
      (build-lw-console))
    pathname))

(defmethod execute ((self lispworks) executable option)
  (exec (namestring executable)
        (mapcar (lambda (option)
                  (destructuring-bind (op arg) option
                    (ecase op
                      (:eval arg)
                      (:load (format nil "(load ~S)" arg))
                      (:system (format nil "(ql:quickload ~S)" (string-upcase arg))))))
                (option-forms option))))
