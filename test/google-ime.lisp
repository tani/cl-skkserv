(in-package :cl-user)
(defpackage :cl-skkserv/test/google-ime
  (:use :cl :1am
        :cl-skkserv/core
        :cl-skkserv/google-ime))
(in-package :cl-skkserv/test/google-ime)

(defparameter *dictionary* (make-instance 'google-ime-dictionary))

(test test-google-ime-dictionary
      ;;変換
      (is (equalp "ここでは着物を脱ぐ" (first (convert *dictionary* "ここではきものをぬぐ")))))
