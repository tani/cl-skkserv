(in-package :cl-user)
(defpackage :lime/tests/skk/numeric
  (:use :cl :1am
        :lime/core/main
        :lime/skk/numeric))
(in-package :lime/tests/skk/numeric)

(defparameter *dictionary* 
  (make-instance 'skk-numeric-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-numeric-dictionary
      ;;辞書の検索
      (is (string= "12月24日" (first (convert *dictionary* "12/24")))))
