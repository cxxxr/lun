(in-package :lun)

(defclass implementation () ())

(defgeneric find-lisp (implementation))
(defgeneric execute (implementation executable options))
