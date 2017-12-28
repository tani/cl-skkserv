(in-package :cl-user)
(defpackage :cl-skkserv/tests/google
  (:use :cl :1am 
        :cl-skkserv/core
        :cl-skkserv/google))
(in-package :cl-skkserv/tests/google)

(defparameter *dictionary* (make-instance 'google-ime-dictionary))

(test test-google-ime-dictionary
      ;;変換
      (is (equalp "ここでは着物を脱ぐ" (first (convert *dictionary* "ここではきものをぬぐ")))))
