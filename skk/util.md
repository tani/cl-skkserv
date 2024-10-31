    (in-package :cl-skkserv/skk)
    (named-readtables:in-readtable papyrus:md-syntax)

# 辞書の読み込み

<!--
Copyright (C) 2017 TANIGUCHI Masaya

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
-->

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
必要に応じてエンコーディングを指定することができます。
既定値は `:eucjp` です。
その後各行に対して構文解析を行いハッシュテーブルに登録します。
戻り値はその登録先のハッシュテーブルです。

```lisp
(defun make-table (pathname &optional (encoding :eucjp))
  (if (probe-file pathname)
      (let* ((octets (read-file-into-byte-vector pathname))
	     (string (babel:octets-to-string octets :encoding encoding)))
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

