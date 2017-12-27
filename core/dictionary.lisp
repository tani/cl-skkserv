(in-package :cl-user)
(defpackage :cl-skkserv/core/dictionary
  (:use :cl)
  (:export dictionary convert complete))
(in-package :cl-skkserv/core/dictionary)

(defclass dictionary () ())
(defgeneric convert (dictionary word)
  (:method-combination append))
(defgeneric complete (dictionary word)
  (:method-combination append))
