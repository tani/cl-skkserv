(in-package :cl-user)
(defpackage :lime/mixed/main
  (:nicknames :lime/mixed)
  (:use :cl)
  (:import-from :lime/core/dictionary dictionary convert complete)
  (:export mixed-dictionary))
(in-package :lime/mixed/main)

(defclass mixed-dictionary (dictionary)
  ((dictionaries :initarg :dictionaries :reader dictionaries)))

(defmethod convert append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (convert d s)) (dictionaries d))))

(defmethod complete append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (complete d s)) (dictionaries d))))
