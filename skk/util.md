    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 辞書の読み込み

SKKの標準の辞書形式はEUCJPでエンコーディングされた次のような形式になります。

```
; これはコメントです
みr /見/覩r;これはアノテーションです/
```

```lisp
(defrule value (+ (not #\/))
  (:lambda (list) (coerce list 'string)))
(defrule key (+ (not #\space))
  (:lambda (list) (coerce list 'string)))
(defrule comment (and #\; (* (not #\newline)))
  (:lambda (list) (declare (ignore list)) nil))
(defrule record (and key #\space #\/ (+ (and value #\/)))
  (:lambda (list) (cons (first list) (mapcar #'car (fourth list)))))
```

アノテーションは削除されます。これは他の辞書サーバーではアノテーションを削除しない場合もあります。この機能は将来的に削除されるかもしれません。

```lisp
(defun remove-comment (s)
  (regex-replace ";.*$" s ""))
```

辞書の読み込みではファイルをバイナリーとして読み込みBabelにより変換します。
その後各行に対して構文解析を行いハッシュテーブルに登録します。
戻り値はその登録先のハッシュテーブルです。

```lisp
(defun make-table (pathname)
  (if (probe-file pathname)
      (let* ((octets (read-file-into-byte-vector pathname))
	     (string (babel:octets-to-string octets :encoding :eucjp)))
	(with-input-from-string (stream string)
	  (do* ((table (make-hash-table :test 'equalp))
		(line (read-line stream nil nil nil)
		      (read-line stream nil nil nil))
		(record (and line (parse '(or comment record) line))
			(and line (parse '(or comment record) line))))
	       ((not line) table)
	    (unless (null record)
	      (setf (gethash (first record) table) 
		    (mapcar #'remove-comment (rest record)))))))
      (make-hash-table :test 'equalp)))
```		

