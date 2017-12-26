(in-package :cl-user)
(defpackage :lime/tests/skk/text
  (:use :cl :1am
        :lime/core/main
        :lime/skk/text))
(in-package :lime/tests/skk/text)

(defparameter *dictionary*
  (make-instance 'skk-text-dictionary :pathname #p"./SKK-JISYO.L"))

(test test-skk-text-dictionary
      ;;検索
      (is (string= "見" (first (convert *dictionary* "みr"))))
      ;;補完
      (is (string= "みわたs" (first (complete *dictionary* "み")))))
