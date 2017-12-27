    (in-package :cl-user)
    (defpackage :cl-skkserv/mixed
      (:nicknames :skkserv/mixed)
      (:use :cl :named-readtables :papyrus :cl-skkserv/core)
      (:export mixed-dictionary))
    (in-package :cl-skkserv/mixed)
    (in-readtable :papyrus)

# 複合辞書

```lisp
(defclass mixed-dictionary (dictionary)
  ((dictionaries :initarg :dictionaries :reader dictionaries)))

(defmethod convert append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (convert d s)) (dictionaries d))))

(defmethod complete append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (complete d s)) (dictionaries d))))
```