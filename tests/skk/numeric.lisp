(in-package :cl-user)
(defpackage :lime/tests/skk/numeric
  (:use :cl :1am :lime/skk/numeric :lime/core/dictionary))
(in-package :lime/tests/skk/numeric)

(defparameter *dictionary* nil)

(test skk-numeric-dictionary
      ;;辞書の生成
      (is (setq *dictionary* (make-instance 'skk-numeric-dictionary :pathname #p"./SKK-JISYO.L")))
      ;;辞書の検索
      (is (string= "12月24日" (first (convert *dictionary* "12/24")))))
