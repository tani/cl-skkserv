(in-package :cl-user)
(defpackage :lime/core/main
  (:nicknames :lime/core :lime)
  (:use :cl)
  (:import-from :lime/core/dictionary dictionary convert complete)
  (:import-from :lime/core/handler handle)
  (:import-from :lime/core/process process)
  (:export dictionary
           convert
           complete
           handle
           process))
(in-package :lime/core/main)
