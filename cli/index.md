    (in-package :cl)
    (defpackage cl-skkserv/cli
      (:use :cl :papyrus :named-readtables)
      (:export main entry-point))
    (in-package :cl-skkserv/cli)
    (in-readtable :papyrus)

# コマンドラインインターフェース

```lisp
(defun serve ()
  (catch :exit
    (format *error-output*
            "Listening on ~a:~a (~a)~%"
            skkserv-user:*address*
            skkserv-user:*port*
            skkserv-user:*encoding*)
    (usocket:socket-server
     skkserv-user:*address*
     skkserv-user:*port*
     #'skkserv:process
     (list skkserv-user:*dictionary*
           skkserv-user:*encoding*)
     :element-type '(unsigned-byte 8))))

(defmacro with-options (options &body body)
  `(progn
     (when (getf ,options :help)
       (unix-opts:describe
	:prefix "Dictionary Server for SKK"
	:usage-of "skkserv [start|stop|handle]"))
     (let* ((home (user-homedir-pathname))
            (init (merge-pathnames #p".skkservrc" home)))
       (when (and (not (getf ,options :no-init nil))
                  (probe-file init))
         (load init)))
     (let ((skkserv-user:*address*
            (getf ,options :address skkserv-user:*address*))
           (skkserv-user:*port*
	    (getf ,options :port skkserv-user:*port*))
           (skkserv-user:*encoding*
	    (getf ,options :encoding skkserv-user:*encoding*)))
       ,@body)))

(defun start (options rest)
  (declare (ignore rest))
  (with-options options
    (if (not (getf options :no-daemon nil))
        (progn
          (daemon:daemonize :exit-parent t)
          (unwind-protect (serve) (daemon:exit)))
        (serve))))

(defun stop (options rest)
  (declare (ignore rest))
  (with-options options
    (usocket:with-client-socket (socket stream skkserv-user:*address* skkserv-user:*port*)
      (format stream "5")
      (force-output stream))))

(defun handle (options rest)
  (with-options options
    (multiple-value-bind (status response)
        (skkserv:handle (first rest) skkserv-user:*dictionary*)
      (format t "~a, ~a" status response))))

(unix-opts:define-opts
  (:name :help
	 :description "ヘルプを表示する"
	 :long "help"
	 :short #\h)
  (:name :address
	 :description "アドレスを指定する"
	 :long "address"
	 :short #\a
	 :arg-parser #'identity
	 :meta-var "ADDRESS")
  (:name :port
	 :description "ポート番号を指定する"
	 :long "port"
	 :short #\p
	 :arg-parser #'parse-integer
	 :meta-var "PORT")
  (:name :encoding
	 :description "文字コードを指定する"
	 :long "encoding"
	 :short #\e
	 :arg-parser #'(lambda (e) (alexandria:format-symbol :keyword "~:@(~a~)" e))
	 :meta-var "ENCODING")
  (:name :no-daemon
	 :description "デーモン化しない"
	 :long "no-daemon")
  (:name :no-init
	 :description "設定ファイルを読み込まない"
	 :long "no-init"))

(defun main (&rest argv)
  (declare (ignorable argv))
  (handler-case
      (cond
	((string= (first argv) "start")
	 (multiple-value-call #'start (unix-opts:get-opts (rest argv))))
	((string= (first argv) "stop")
	 (multiple-value-call #'stop (unix-opts:get-opts (rest argv))))
	((string= (first argv) "handle")
	 (multiple-value-call #'handle (unix-opts:get-opts (rest argv))))
	(t (unix-opts:describe
	    :prefix "Dictionary Server for SKK"
	    :usage-of "skkserv [start|stop|handle]")))
    (error (c)
      (princ c *error-output*)
      (return-from main))
    (usocket:connection-refused-error (c)
      (princ c *error-output*)
      (return-from main))))

(defun entry-point ()
  (apply #'main uiop:*command-line-arguments*))
```
