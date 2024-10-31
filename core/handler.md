    (in-package :cl-skkserv/core)
    (named-readtables:in-readtable papyrus:md-syntax)

# ハンドラー

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

ハンドラーはクライアント要求を解釈し適切な辞書機能を呼び出す役割があります。

## クライアント要求の構文

パーサーコンビネーターのesrapによって構文解析しています。
クライアント要求には5つの種類があり、見出しの有無によって二種類に分類されます。
見出しがあるときは、空白文字が終了文字になります。


| 要求の種類 | 見出しの有無 | 意味 |
| -------- | ----------- | ---- |
| 0        | 無          | 辞書サーバーとの通信を終了する |
| 1        | 有          | 見出しに対して変換候補を返す |
| 2        | 無          | 辞書サーバーの版番号を返す   |
| 3        | 無          | 辞書サーバーのホストとアドレスを返す |
| 4        | 有          | 見出しに対して補完候補を返す |
| 5        | 無          | 辞書サーバーを終了する      |

なお5番要求はcl-skkservの拡張であり、`skkserv`コマンドから送信されます。


```lisp
(defrule convert-request (and #\1 (+ (not #\space)) #\space)
  (:lambda (list) (list (parse-integer (first list)) (format nil "~{~a~}" (second list)))))

(defrule complete-request (and #\4 (+ (not #\space)) #\space)
  (:lambda (list) (list (parse-integer (first list)) (format nil "~{~a~}" (second list)))))

(defrule other-request (or #\0 #\2 #\3 #\5)
  (:lambda (list) (list (parse-integer list))))
  
(defrule request (or convert-request
                     complete-request
                     other-request))
```

## サーバー応答の構文

ハンドラーは文字列と辞書を受け取り要求の種類と文字列の多値を返す関数です。
クライアント要求を前述の構文で解釈したあと次の構文で記述された文字列を返します。

0番要求は`nil`を返します。

1番要求は候補の有無で返却値の文法が変ります。
まず候補がある場合は`1/foo/bar/baz/\n`のように`1`から始まり候補が`/`区切りで続き最後に改行文字列で終ります。
次に候補が無場合ですが単に`4`で始まるなんらかの文字列を返します。

2番要求は辞書サーバーの版番号に空白文字を追加したものを返します。

3番要求は偽の文字列`"hostname:addr:...: "`を返します。
これはcl-skkservのcoreが`usocket`に依存しないようにするためです。
そして値はyaskkservを参考にしています。


4番要求は`1/foo/bar/baz/\n`のように`1`から始まり候補が`/`区切りで続き最後に改行文字列で終ります。


5番要求は`nil`を返します。

```lisp
(defun handle (string dictionary)
  ;; http://umiushi.org/~wac/yaskkserv/#protocol
  (let ((request (parse 'request string)))
    (values
     (first request)
     (case (first request)
       (1 (let ((result (convert dictionary (second request))))
            (format nil "~A/~{~A/~}~%" (if result 1 4) result)))
       (2 (format nil "~a " (component-version (find-system :cl-skkserv))))
       (3 (format nil "hostname:addr:...: "))
       (4 (let ((result (complete dictionary (second request))))
            (format nil "1/~{~A/~}~%" result)))))))
```
