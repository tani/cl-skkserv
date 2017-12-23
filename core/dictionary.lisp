(in-package :cl)
(defpackage :lime/core/dictionary
  (:use :cl)
  (:export dictionary lookup))
(in-package :lime/core/dictionary)

(defclass dictionary () ())
(defgeneric lookup (dictionary word))
