(in-package :cl-user)
(defpackage :cl-skkserv/skk/main
  (:nicknames :cl-skkserv/skk :skkserv/skk)
  (:use :cl)
  (:import-from :cl-skkserv/core/main dictionary convert)
  (:import-from :cl-skkserv/skk/text skk-text-dictionary)
  (:import-from :cl-skkserv/skk/numeric skk-numeric-dictionary)
  (:import-from :cl-skkserv/skk/lisp skk-lisp-dictionary) 
  (:export skk-dictionary
           skk-text-dictionary
           skk-numeric-dictionary
           skk-lisp-dictionary))
(in-package :cl-skkserv/skk/main)

(defclass skk-dictionary (skk-text-dictionary skk-numeric-dictionary skk-lisp-dictionary) ())
