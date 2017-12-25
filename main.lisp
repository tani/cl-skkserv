(in-package :cl)
(defpackage :lime/main
  (:nicknames :lime)
  (:use :cl
        :lime/core/main
        :lime/skk/main)
  (:export server-start
           server-stop
           dictionary
           lookup
           mixed-dictionary
           skk-dictionary
           skk-text-dictionary
           skk-pattern-dictionary
           skk-lisp-dictionary))
(in-package :lime/main)

