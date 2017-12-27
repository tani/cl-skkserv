(in-package :cl-user)
(defpackage :cl-skkserv/tests/skk/lisp
  (:use :cl :1am
        :cl-skkserv/core/main
        :cl-skkserv/skk/lisp))
(in-package :cl-skkserv/tests/skk/lisp)

(defparameter *dictionary* 
  (make-instance 'skk-lisp-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-skk-lisp-dictionary
      ;;検索
      (is (string= "DOS/V" (first (convert *dictionary* "dosv"))))
      ;;補完
      (is (string= "dosv" (first (complete *dictionary* "dosv")))))

