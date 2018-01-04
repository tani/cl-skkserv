(in-package :cl)
(defpackage cl-skkserv/cli
  (:use :cl)
  (:export main entry-point))
(in-package :cl-skkserv/cli)

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
     (let* ((home (user-homedir-pathname))
            (init (merge-pathnames #p".skkservrc" home)))
       (when (and (not (gethash "--no-init" ,options nil))
                  (probe-file init))
         (load init)))
     (let ((skkserv-user:*address*
             (gethash "--address" ,options skkserv-user:*address*))
           (skkserv-user:*port*
	    (gethash "--port" ,options skkserv-user:*port*))
           (skkserv-user:*encoding*
             (alexandria:format-symbol
              :keyword "~:@(~a~)"
              (gethash "--encoding" ,options skkserv-user:*encoding*))))
       ,@body)))

(defun start (options rest)
  (declare (ignore rest))
  (with-options options
    (if (not (gethash "--no-daemon" options nil))
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

(defun help ()
  (princ "SKKクライアント向け辞書サーバー

使い方:

  skkserv コマンド [オプション]

コマンド:

  start  辞書サーバーを立ち上げる
  stop   辞書サーバーに終了命令を送る
  handle 辞書サーバーを経由せずに要求を処理する

オプション:
  --no-init   設定ファイルを読み込まない
  --no-daemon 辞書サーバーをデーモン化しない
  --address   辞書サーバーのアドレスを設定する
  --port      辞書サーバーのポート番号を指定する
  --encoding  辞書サーバーの文字コードを指定する
"))

(defun main (&rest argv)
  (declare (ignorable argv))
  (handler-case
      (let ((trivial-argv:*boolean-options* '("--no-init" "--no-daemon"))
	    (trivial-argv:*number-options* '("--port"))
	    (trivial-argv:*string-options* '("--address" "--encoding")))
	(cond
	  ((string= (first argv) "start")
	   (multiple-value-call #'start (trivial-argv:parse (rest argv))))
	  ((string= (first argv) "stop")
	   (multiple-value-call #'stop (trivial-argv:parse (rest argv))))
	  ((string= (first argv) "handle")
	   (multiple-value-call #'handle (trivial-argv:parse (rest argv))))
	  (t (help))))
    (error (c)
      (princ c *error-output*)
      (return-from main))
    (usocket:connection-refused-error (c)
      (princ c *error-output*)
      (return-from main))))

(defun entry-point ()
  (apply #'main uiop:*command-line-arguments*))
    
