(in-package :cl)
(defpackage :lime/skk/main
  (:nicknames :lime/skk)
  (:use :cl)
  (:import-from :lime/core/main dictionary convert)
  (:import-from :lime/skk/text skk-text-dictionary)
  (:import-from :lime/skk/numeric skk-numeric-dictionary)
  (:import-from :lime/skk/lisp skk-lisp-dictionary) 
  (:export skk-dictionary
           skk-text-dictionary
           skk-numeric-dictionary
           skk-lisp-dictionary))
(in-package :lime/skk/main)

(defclass skk-dictionary (skk-text-dictionary skk-numeric-dictionary skk-lisp-dictionary) ())
