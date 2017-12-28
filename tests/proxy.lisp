(in-package :cl-user)
(defpackage :cl-skkserv/tests/proxy
  (:use :cl :1am 
        :cl-skkserv/core
        :cl-skkserv/proxy))
(in-package :cl-skkserv/tests/proxy)

(defparameter *dictionary*
  (make-instance 'proxy-dictionary
                 :address "localhost"
                 :port 1178
                 :encoding :eucjp))

(test test-proxy-dictionary
      ;;変換
      (is (equalp "見" (first (convert *dictionary* "みr")))))
