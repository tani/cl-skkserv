(in-package :cl-user)
(defpackage :lime/tests/core/handler
  (:use :cl :1am 
        :lime/skk/main
        :lime/core/dictionary
        :lime/core/handler))
(in-package :lime/tests/core/handler)

(defparameter *dictionary*
  (make-instance 'skk-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-handler
      (is (equalp (multiple-value-list (handle "1a " *dictionary*))
                  (list 1 (format nil "1/~{~A/~}~%" (convert *dictionary* "a")))))
      (is (equalp (multiple-value-list (handle "4a " *dictionary*))
                  (list 4 (format nil "1/~{~A/~}~%" (complete *dictionary* "a"))))))


