(in-package :cl)
(defpackage :lime/skk/main
  (:nicknames :lime/skk)
  (:use :cl
        :lime/core/dictionary
        :lime/skk/text
        :lime/skk/pattern
        :lime/skk/lisp)
  (:export skk-dictionary
           skk-text-dictionary
           skk-pattern-dictionary
           skk-lisp-dictionary))
(in-package :lime/skk/main)

(defclass skk-dictionary (skk-text-dictionary skk-pattern-dictionary skk-lisp-dictionary) ())
(defmethod lookup ((d skk-dictionary) (s string))
  (or (call-next-method)
      (call-next-method)
      (call-next-method)))
