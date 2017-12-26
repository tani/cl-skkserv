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
               lime/main)
  :in-order-to ((test-op (test-op lime/tests))))

(defsystem lime/tests
  :class :package-inferred-system
  :depends-on (1am
               lime
               lime/tests/skk/text
               lime/tests/skk/numeric
               lime/tests/skk/lisp)
  :perform (test-op (o c) (symbol-call :1am '#:run)))
                    
