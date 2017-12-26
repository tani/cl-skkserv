(in-package :cl-user)
(defpackage :lime/tests/skk/lisp
  (:use :cl :1am
        :lime/core/main
        :lime/skk/lisp))
(in-package :lime/tests/skk/lisp)

(defparameter *dictionary* 
  (make-instance 'skk-lisp-dictionary :pathname #p"./SKK-JISYO.L"))

(test test-skk-lisp-dictionary
      ;;検索
      (is (string= "DOS/V" (first (convert *dictionary* "dosv"))))
      ;;補完
      (is (string= "dosv" (first (complete *dictionary* "dosv")))))

