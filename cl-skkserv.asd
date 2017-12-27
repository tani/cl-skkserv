(defclass papyrus (cl-source-file)
  ((type :initform "md")))

(defsystem cl-skkserv
  :class :package-inferred-system
  :description "skkserv for Common Lisp"
  :license "GPLv3"
  :author "asciian"
  :version "0.0.0"
  :depends-on (alexandria
               cl-ppcre
               esrap
               babel
               jp-numeral
               usocket
               drakma
               flexi-streams
               yason
               papyrus
               named-readtables
               trivial-download
               cl-skkserv/core/main
               cl-skkserv/skk/main
               cl-skkserv/google/main
               cl-skkserv/mixed/main
               cl-skkserv/proxy/main
               cl-skkserv/user/main)
  :in-order-to ((test-op (test-op cl-skkserv/tests))))

(defsystem cl-skkserv/tests
  :class :package-inferred-system
  :depends-on (1am
               flexi-streams
               cl-skkserv
               cl-skkserv/tests/core/handler
               cl-skkserv/tests/core/process
               cl-skkserv/tests/skk/text
               cl-skkserv/tests/skk/numeric
               cl-skkserv/tests/skk/lisp
               cl-skkserv/tests/mixed/main)
  :perform (test-op (o c) (symbol-call :1am '#:run)))
