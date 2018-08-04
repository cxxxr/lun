(defsystem "lun"
  :depends-on ("cffi")
  :serial t
  :components ((:file "src/package")
               (:file "src/util")
               (:file "src/variables")
               (:file "src/config")
               (:file "src/command-line-option")
               (:file "src/implementation")
               (:file "src/lispworks")
               (:file "src/main")))
