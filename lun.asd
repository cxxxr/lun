(defsystem "lun"
  :depends-on ("cffi")
  :serial t
  :components ((:file "src/package")
               (:file "src/variables")
               (:file "src/exec")
               (:file "src/implementation")
               (:file "src/lispworks")
               (:file "src/lun")))
