(in-package :cl)
(defpackage :lime/tests/skk/pattern
  (:use :cl :rove :lime/skk/pattern :lime/core/dictionary))
(in-package :lime/tests/skk/pattern)

(defparameter *dictionary* nil)

(deftest skk-pattern-dictionary
  (testing
   "辞書の生成"
   (ok (setq *dictionary* (make-instance 'skk-pattern-dictionary :filespec #p"./SKK-JISYO.L"))))
  (testing 
   "辞書の検索"
   (ok (string= "12月24日" (first (lookup *dictionary* "12/24"))))))
