(defsystem lime
  :class :package-inferred-system
  :description "lisp input method editor"
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
               yason
               flex-stream
               lime/main)
  :in-order-to ((test-op (test-op lime/tests))))

(defsystem lime/tests
  :class :package-inferred-system
  :depends-on (1am
               flexi-streams
               lime
               lime/tests/core/handler
               lime/tests/core/process
               lime/tests/skk/text
               lime/tests/skk/numeric
               lime/tests/skk/lisp
               lime/tests/mixed/main)
  :perform (test-op (o c) (symbol-call :1am '#:run)))
