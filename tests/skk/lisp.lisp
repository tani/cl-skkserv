(in-package :cl)
(defpackage :lime/tests/skk/lisp
  (:use :cl :rove :lime/skk/lisp :lime/core/dictionary))
(in-package :lime/tests/skk/lisp)

(defparameter *dictionary* nil)

(deftest skk-lisp-dictionary
  (testing
   "辞書の生成"
   (ok (setf *dictionary* (make-instance 'skk-lisp-dictionary :filespec #p"./SKK-JISYO.L"))))
  (testing 
   "辞書の検索"
   (ok (string= "DOS/V" (first (convert *dictionary* "dosv"))))))
