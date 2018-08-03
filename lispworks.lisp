(in-package :lun)

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
