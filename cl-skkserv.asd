(defclass md (cl-source-file)
  ((type :initform "md")))

(defsystem cl-skkserv
  :description "skkserv with Common Lisp"
  :license "GPLv3"
  :author "Masaya Taniguchi"
  :version "0.9.0"
  :depends-on (cl-skkserv/core
               cl-skkserv/google-ime
               cl-skkserv/proxy
               cl-skkserv/skk
               cl-skkserv/mixed
               cl-skkserv/user)
  :in-order-to ((test-op (test-op cl-skkserv/test))
                (build-op (build-op cl-skkserv/cli))))

(defsystem cl-skkserv/cli
  :depends-on (cl-skkserv papyrus daemon usocket usocket-server alexandria unix-opts named-readtables)
  :build-operation program-op
  :build-pathname "skkserv"
  :entry-point "cl-skkserv/cli:entry-point"
  :components ((:module "cli"
                :components
                ((:md "index")))))

 (defsystem cl-skkserv/core
  :depends-on (alexandria esrap babel papyrus named-readtables)
  :serial t
  :components ((:module "core"
                :components
                ((:md "index")
                 (:md "dictionary")
                 (:md "handler")
                 (:md "process")))))

(defsystem cl-skkserv/skk
  :depends-on (alexandria cl-ppcre esrap babel jp-numeral papyrus cl-skkserv/core named-readtables)
  :serial t
  :components ((:module "skk"
                :components
                ((:md "index")
                 (:md "util")
                 (:md "lisp")
                 (:md "numeric")
                 (:md "text")))))

(defsystem cl-skkserv/mixed
  :depends-on (papyrus cl-skkserv/core named-readtables)
  :serial t
  :components ((:module "mixed"
                :components
                ((:md "index")))))

(defsystem cl-skkserv/google-ime
  :depends-on (papyrus drakma flexi-streams yason cl-skkserv/core named-readtables)
  :serial t
  :components ((:module "google-ime"
                :components
                ((:md "index")))))

(defsystem cl-skkserv/proxy
  :depends-on (cl-ppcre papyrus usocket babel cl-skkserv/core named-readtables)
  :serial t
  :components ((:module "proxy"
                :components
                ((:md "index")))))

(defsystem cl-skkserv/user
  :depends-on (papyrus cl-skkserv/core cl-skkserv/skk cl-skkserv/mixed cl-skkserv/google-ime cl-skkserv/proxy named-readtables)
  :serial t
  :components ((:module "user"
                :components
                ((:md "index")))))

(defsystem cl-skkserv/test
  :depends-on (1am flexi-streams cl-skkserv)
  :serial t
  :components ((:module "test"
                :components
                ((:file "core")
                 (:file "skk")
                 (:file "mixed")
                 (:file "google-ime")
                 (:file "proxy"))))
  :perform (test-op (o c) (symbol-call :1am '#:run)))
