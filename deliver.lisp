(in-package "CL-USER")

(lw:set-default-character-element-type 'cl:character)

(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(load-all-patches)
(uiop:symbol-call :ql :quickload :lun)

(deliver (find-symbol "MAIN" :lun)
         "./lun"
         0 
         :keep-pretty-printer T)
