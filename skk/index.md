    (in-package :cl-user)
    (defpackage :cl-skkserv/skk
      (:nicknames :skkserv/skk)
      (:use :cl :alexandria :cl-ppcre :esrap :babel :jp-numeral :named-readtables :papyrus :cl-skkserv/core)
      (:export skk-dictionary
              skk-text-dictionary
              skk-numeric-dictionary
              skk-lisp-dictionary))
    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 目次