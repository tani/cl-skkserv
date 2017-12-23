(in-package :cl)
(defpackage :lime/tests/skk/text
  (:use :cl :rove :trivial-download :lime/skk/text :lime/core/dictionary))
(in-package :lime/tests/skk/text)

(setup
 (unless (probe-file #p"./SKK-JISYO.L")
   (download "http://openlab.jp/skk/skk/dic/SKK-JISYO.L" #p"./SKK-JISYO.L"))
)

(deftest skk-textdictionary
  (testing
   "単純な辞書の生成"
   (ok (make-instance 'skk-text-dictionary :filespec #p"./SKK-JISYO.L")))
  (testing 
   "辞書の検索機能のテスト"
   (ok (lookup (make-instance 'skk-text-dictionary :filespec #p"./SKK-JISYO.L") "みr"))))
