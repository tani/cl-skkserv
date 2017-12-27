(in-package :cl-user)
(defpackage :cl-skkserv/user/main
  (:nicknames :cl-skkserv/user :skkserv/user :cl-skkserv-user :skkserv-user)
  (:use :cl :cl-skkserv/skk/main :asdf :trivial-download)
  (:export *dictionary* *address* *port* *encoding*))
(in-package :cl-skkserv/user/main)

(defvar jisyo (merge-pathnames #p"data/SKK-JISYO.L" (component-pathname (find-system :cl-skkserv))))
(unless (probe-file jisyo)
  (download "http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.L" jisyo))

(defparameter *dictionary* (make-instance 'skk-dictionary :pathname jisyo))
(defparameter *address* "localhost")
(defparameter *port* 1178)
(defparameter *encoding* :euc-jp)
