(in-package :cl-user)
(defpackage :cl-skkserv/tests/core/handler
  (:use :cl :1am 
        :cl-skkserv/skk/main
        :cl-skkserv/core/dictionary
        :cl-skkserv/core/handler))
(in-package :cl-skkserv/tests/core/handler)

(defparameter *dictionary*
  (make-instance 'skk-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-handler
      (is (equalp (multiple-value-list (handle "1a " *dictionary*))
                  (list 1 (format nil "1/~{~A/~}~%" (convert *dictionary* "a")))))
      (is (equalp (multiple-value-list (handle "4a " *dictionary*))
                  (list 4 (format nil "1/~{~A/~}~%" (complete *dictionary* "a"))))))


