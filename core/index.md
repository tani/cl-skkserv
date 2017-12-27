    (in-package :cl-user)
    (defpackage cl-skkserv/core
      (:nicknames :skkserv/core :cl-skkserv :skkserv)
      (:use :cl :asdf :alexandria :esrap :babel :papyrus :named-readtables)
      (:export dictionary
               convert
               complete
               handle
               process
               write-response
               read-request))
    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# 目次