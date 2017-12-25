(in-package :cl)
(defpackage :lime/tests/skk/text
  (:use :cl :rove :lime/skk/text :lime/core/dictionary))
(in-package :lime/tests/skk/text)

(defparameter *dictionary* nil)

(deftest skk-textdictionary
  (testing
   "辞書の生成"
   (ok (setq *dictionary* (make-instance 'skk-text-dictionary :pathname #p"./SKK-JISYO.L"))))
  (testing 
   "辞書の検索"
   (ok (string= "見" (first (convert *dictionary* "みr"))))))
