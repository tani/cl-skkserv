(in-package :cl)
(defpackage :lime/main
  (:nicknames :lime)
  (:use :cl :lime/core/main :lime/skk/main)
  (:export handle
           process
           dictionary
           lookup
           complete
           mixed-dictionary
           skk-dictionary
           skk-text-dictionary
           skk-pattern-dictionary
           skk-lisp-dictionary))
(in-package :lime/main)
