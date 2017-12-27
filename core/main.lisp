(in-package :cl-user)
(defpackage :cl-skkserv/core/main
  (:nicknames :cl-skkserv/core :skkserv/core :cl-skkserv :skkserv)
  (:use :cl)
  (:import-from :cl-skkserv/core/dictionary dictionary convert complete)
  (:import-from :cl-skkserv/core/handler handle)
  (:import-from :cl-skkserv/core/process process)
  (:export dictionary
           convert
           complete
           handle
           process))
(in-package :cl-skkserv/core/main)
