(in-package :cl-user)
(defpackage :lime/user/main
  (:nicknames :lime/user :lime-user)
  (:use :cl :lime/skk/main :asdf :trivial-download)
  (:export *dictionary* *address* *port* *encoding*))
(in-package :lime/user/main)

(defvar jisyo (merge-pathnames #p"data/SKK-JISYO.L" (component-pathname (find-system :lime))))
(unless (probe-file jisyo)
  (download "http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.L" jisyo))

(defparameter *dictionary* (make-instance 'skk-dictionary :pathname jisyo))
(defparameter *address* "localhost")
(defparameter *port* 1178)
(defparameter *encoding* :euc-jp)
