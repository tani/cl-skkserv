(defsystem lime
  :class :package-inferred-system
  :description "lisp input method editor"
  :license "GPLv3"
  :author "asciian"
  :version "0.0.0"
  :depends-on (alexandria
               esrap
               babel
               usocket
               jp-numeral
               lime/main)
  :in-order-to ((test-op (test-op lime/tests))))

(defsystem lime/tests
  :class :package-inferred-system
  :depends-on (rove
               lime
               lime/tests/skk/text
               lime/tests/skk/pattern
               lime/tests/skk/lisp)
  :perform (test-op (o c) (symbol-call :rove '#:run c)))
                    
