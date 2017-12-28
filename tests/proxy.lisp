(in-package :cl-user)
(defpackage :cl-skkserv/tests/proxy
  (:use :cl :1am 
        :cl-skkserv/core
        :cl-skkserv/proxy))
(in-package :cl-skkserv/tests/proxy)

(defparameter *dictionary* (make-instance 'proxy-dictionary :address "" :port "" :encoding :eucjp))

(test test-google-ime-dictionary
      ;;変換
      (is (equalp "ここでは着物を脱ぐ" (first (convert *dictionary* "ここではきものをぬぐ")))))
