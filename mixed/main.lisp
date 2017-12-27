(in-package :cl-user)
(defpackage :cl-skkserv/mixed/main
  (:nicknames :cl-skkserv/mixed :skkserv/mixed)
  (:use :cl)
  (:import-from :cl-skkserv/core/dictionary dictionary convert complete)
  (:export mixed-dictionary))
(in-package :cl-skkserv/mixed/main)

(defclass mixed-dictionary (dictionary)
  ((dictionaries :initarg :dictionaries :reader dictionaries)))

(defmethod convert append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (convert d s)) (dictionaries d))))

(defmethod complete append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (complete d s)) (dictionaries d))))
