(in-package :cl-user)
(defpackage cl-skkserv/tests/skk
  (:use :cl :1am 
        :cl-skkserv/core
        :cl-skkserv/skk))
(in-package :cl-skkserv/tests/skk)

(defparameter *lisp-dictionary* 
  (make-instance 'skk-lisp-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-lisp-dictionary
      ;;検索
      (is (string= "DOS/V" (first (convert *lisp-dictionary* "dosv"))))
      ;;補完
      (is (string= "dosv" (first (complete *lisp-dictionary* "dosv")))))

(defparameter *numeric-dictionary* 
  (make-instance 'skk-numeric-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-numeric-dictionary
      ;;辞書の検索
      (is (string= "12月24日" (first (convert *numeric-dictionary* "12/24")))))

(defparameter *text-dictionary*
  (make-instance 'skk-text-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-text-dictionary
      ;;検索
      (is (string= "見" (first (convert *text-dictionary* "みr"))))
      ;;補完
      (is (string= "みわたs" (first (complete *text-dictionary* "み")))))