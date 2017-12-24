(in-package :cl)
(defpackage :lime/core/main
  (:nicknames :lime/core)
  (:use :cl
        :lime/core/dictionary
        :lime/core/server
        :lime/core/mixed)
  (:export dictionary
           lookup
           mixed-dictionary
           server-start
           server-stop))
(in-package :lime/core/main)
