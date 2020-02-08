    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# プロセス

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

プロセスは辞書サーバーとクライアントとのコネクションを管理します。またクライアントからの要求とサーバーとの間でバイナリーと文字列での相互変換も行っています。これは、一般にSKKサーバーのプロトコルの文字コードがEUC-JPである一方内部的にはOSや処理系に依存した文字コードが使用されるため毎度変換する必要があるからです。

## 読み込み

クライアントからの要求は常に一桁の数字から始まることから数字がくるまで要求を無視し、数字が来たところで読み込みを開始します。このとき1番要求と4番要求のときは空白文字列が来るまでを見出しとして読み込みます。

```lisp
(defun read-request (stream)
  (loop :for b := (read-byte stream)
        :for c := (code-char b)
        :when (char<= #\0 c #\5) :return
           (coerce 
            (ecase c
              ((#\0 #\2 #\3 #\5) (list b))
              ((#\1 #\4)
               (loop :for d := (read-byte stream)
                     :for e := (code-char d)
                     :collecting d :into s
                     :until (char= e #\space)
                     :finally (return (append (list b) s)))))
            '(vector (unsigned-byte 8)))))
```

## 書き込み

読み込みも書き込みも文字コードの変換は行っておらず単純にバイナリの読み書きのみを行います。文字コードの取扱はプロセス関数で行います。

```lisp
(defun write-response (stream response)
  (write-sequence response stream)
  (force-output stream))
```

## プロセス

プロセスは要求を読み込み文字コードの変換を行います。文字コードの変換にはBabelが使われます。もし要求が5番要求であるとハンドラーが解釈した場合は`:exit`を呼び出し関数に向って投げます。これは一般にusocketのサーバーよりも上位の関数で補足されます。このときprocess関数を脱出するだけでなくusocketのサーバーはソケットを閉じる操作などを行います。ハンドラーが関数が終了すると次の要求を読み込むまで待機します。つまり5番要求以外ではこの関数が終了することがありません。

```lisp
(defun process (stream dictionary encoding)
  (loop :for request := (octets-to-string (read-request stream) :encoding encoding)
        :for (status response) := (multiple-value-list (handle request dictionary))
        :until (= status 0)
        :if (= status 5) :do
           (throw :exit 1)
        :else :do
           (write-response stream (string-to-octets response :encoding encoding))))
```

