(in-package :cl)
(defpackage :lime/core/mixed
  (:use :cl :lime/core/dictionary)
  (:export mixed-dictionary))
(in-package :lime/core/mixed)

(defclass mixed-dictionary (dictionary)
  ((dictionaries :initarg :dictionaries :reader dictionaries)))

(defmethod lookup ((d mixed-dictionary) (s string))
  (dolist (d (dictionaries d))
    (when (gethash s d)
      (return (gethash s d)))))
