(in-package :cl-user)
(defpackage :cl-skkserv/test/mixed
  (:use :cl :1am 
        :cl-skkserv/skk
        :cl-skkserv/core
        :cl-skkserv/mixed))
(in-package :cl-skkserv/test/mixed)

(defparameter *text*
  (make-instance 'skk-text-dictionary :pathname #p"./data/SKK-JISYO.L"))
(defparameter *numeric*
  (make-instance 'skk-text-dictionary :pathname #p"./data/SKK-JISYO.L"))
(defparameter *mixed*
  (make-instance 'mixed-dictionary :dictionaries (list *text* *numeric*)))

(test test-mixed-dictionary
      ;;変換
      (is (equalp (convert *mixed* "12")
                  (append (convert *text* "12") (convert *numeric* "12"))))
      ;;補完
      (is (equalp (complete *mixed* "12")
                  (append (complete *text* "12") (complete *numeric* "12")))))
