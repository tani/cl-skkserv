(in-package :cl-user)
(defpackage :cl-skkserv/tests/skk/text
  (:use :cl :1am
        :cl-skkserv/core/main
        :cl-skkserv/skk/text))
(in-package :cl-skkserv/tests/skk/text)

(defparameter *dictionary*
  (make-instance 'skk-text-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-text-dictionary
      ;;検索
      (is (string= "見" (first (convert *dictionary* "みr"))))
      ;;補完
      (is (string= "みわたs" (first (complete *dictionary* "み")))))
