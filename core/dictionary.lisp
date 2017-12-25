(in-package :cl)
(defpackage :lime/core/dictionary
  (:use :cl)
  (:export dictionary convert complete))
(in-package :lime/core/dictionary)

(defclass dictionary () ())
(defgeneric convert (dictionary word)
  (:method-combination append))
(defgeneric complete (dictionary word)
  (:method-combination append))
