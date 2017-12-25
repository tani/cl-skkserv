(in-package :cl)
(defpackage :lime/tests/skk/numeric
  (:use :cl :rove :lime/skk/numeric :lime/core/dictionary))
(in-package :lime/tests/skk/numeric)

(defparameter *dictionary* nil)

(deftest skk-numeric-dictionary
  (testing
   "辞書の生成"
   (ok (setq *dictionary* (make-instance 'skk-numeric-dictionary :pathname #p"./SKK-JISYO.L"))))
  (testing 
   "辞書の検索"
   (ok (string= "12月24日" (first (convert *dictionary* "12/24"))))))
