    (in-package :cl-user)
    (defpackage :cl-skkserv/user
      (:nicknames :skkserv/user :cl-skkserv-user :skkserv-user)
      (:use :cl :asdf :trivial-download :named-readtables :papyrus :cl-skkserv/skk)
      (:export *dictionary* *address* *port* *encoding*))
    (in-package :cl-skkserv/user)
    (in-readtable :papyrus)

# 設定ファイル

```lisp
(defvar jisyo (merge-pathnames #p"data/SKK-JISYO.L" (component-pathname (find-system :cl-skkserv))))
(unless (probe-file jisyo)
  (download "http://openlab.ring.gr.jp/skk/skk/dic/SKK-JISYO.L" jisyo))
```

```lisp
(defparameter *dictionary* (make-instance 'skk-dictionary :pathname jisyo))
(defparameter *address* "localhost")
(defparameter *port* 1178)
(defparameter *encoding* :euc-jp)
```