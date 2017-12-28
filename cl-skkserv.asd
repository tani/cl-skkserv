(defclass papyrus (cl-source-file)
  ((type :initform "md")))

(defsystem cl-skkserv
  :description "skkserv for Common Lisp"
  :license "GPLv3"
  :author "asciian"
  :version "0.0.0"
  :depends-on (cl-skkserv/core
               cl-skkserv/skk
               cl-skkserv/mixed
               cl-skkserv/proxy
               cl-skkserv/google-ime
               cl-skkserv/user)
  :in-order-to ((test-op (test-op cl-skkserv/tests))))

(defsystem cl-skkserv/core
  :depends-on (alexandria esrap babel papyrus named-readtables)
  :serial t
  :components ((:module "core"
                :components
                ((:papyrus "index")
                 (:papyrus "dictionary")
                 (:papyrus "handler")
                 (:papyrus "process")))))

(defsystem cl-skkserv/skk
  :depends-on (alexandria cl-ppcre esrap babel jp-numeral papyrus named-readtables cl-skkserv/core)
  :serial t
  :components ((:module "skk"
                :components
                ((:papyrus "index")
                 (:papyrus "util")
                 (:papyrus "lisp")
                 (:papyrus "numeric")
                 (:papyrus "text")
                 (:papyrus "skk")))))

(defsystem cl-skkserv/mixed
  :depends-on (papyrus named-readtables cl-skkserv/core)
  :serial t
  :components ((:module "mixed"
                :components
                ((:papyrus "index")))))

(defsystem cl-skkserv/google-ime
  :depends-on (papyrus drakma flexi-streams yason named-readtables cl-skkserv/core)
  :serial t
  :components ((:module "google-ime"
                :components
                ((:papyrus "index")))))

(defsystem cl-skkserv/proxy
  :depends-on (papyrus usocket babel named-readtables cl-skkserv/core)
  :serial t
  :components ((:module "proxy"
                :components
                ((:papyrus "index")))))

(defsystem cl-skkserv/user
  :depends-on (papyrus named-readtables cl-skkserv/core)
  :serial t
  :components ((:module "mixed"
                :components
                ((:papyrus "index")))))

(defsystem cl-skkserv/tests
  :depends-on (1am flexi-streams cl-skkserv)
  :serial t
  :components ((:module "tests"
                :components 
                ((:file "core")
                 (:file "skk")
                 (:file "mixed")
                 (:file "google-ime"))))
  :perform (test-op (o c) (symbol-call :1am '#:run)))
