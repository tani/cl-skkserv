    (in-package :cl-user)
    (defpackage :cl-skkserv/proxy
      (:nicknames :skkserv/proxy)
      (:use :cl :usocket :babel :cl-ppcre :named-readtables :papyrus :cl-skkserv/core)
      (:export proxy-dictionary))
    (in-package :cl-skkserv/proxy)
    (in-readtable :papyrus)

# プロキシー辞書

<!--
Copyright (C) 2017 asciian

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

他のSKK辞書サーバーを利用するための辞書クラスです。

## 使い方

設定ファイルで`*dictionary*`値を以下のように上書きする必要があります。

    (setq *dictionary* (make-instance 'proxy-dictionary :address "localhost" :port 1178 :encoding :eucjp))

### クラス

辞書サーバーのアドレスとポート番号と文字コードを指定する必要があります。
各スロットの既定値は以下の通りです。

| スロット名 | 既定値    |
| -------- | --------- |
| ADDRESS  | localhost |
| PORT     | 1178      |
| ENCODING | :EUCJP    |


```lisp
(defclass proxy-dictionary (dictionary)
  ((address :initform "localhost" :initarg :address :reader address-of)
   (port :initform 1178 :initarg :port :reader port-of)
   (encoding :initform :eucjp :initarg :encoding :reader encoding-of)))
```

### 変換機能

指定された辞書サーバーに対して、他のクライアントと同様にソケット通信で要求しその結果をもとに変換候補の列を作り返します。
このとき辞書サーバーからの応答が「候補なし(4)」だった場合は、空列を返します。

```lisp
(defmethod convert append ((d proxy-dictionary) (s string))
  (with-client-socket (socket stream (address-of d) (port-of d) :element-type '(unsigned-byte 8))
    (let* ((request (format nil "1~a " s))
           (binary (string-to-octets request :encoding (encoding-of d))))
      (write-sequence binary stream)
      (force-output stream))
    (loop :for b := (read-byte stream)
       :collecting b :into v
       :until (char= (code-char b) #\newline)
       :finally
       (write-byte (char-code #\0) stream)
       (let* ((r (coerce v '(vector (unsigned-byte 8))))
	      (s (octets-to-string r :encoding (encoding-of d))))
	 (return (rest (split "/" s)))))))
```	
	
### 補完機能

指定された辞書サーバーに対して、他のクライアントと同様にソケット通信で要求しその結果をもとに補完候補の列を作り返します。
このとき辞書サーバーからの応答が「候補なし(4)」だった場合は、空列を返します。


```lisp
(defmethod complete append ((d proxy-dictionary) (s string))
  (with-client-socket (socket stream (address-of d) (port-of d) :element-type '(unsigned-byte 8))
    (let* ((request (format nil "4~a " s))
           (binary (string-to-octets request :encoding (encoding-of d))))
      (write-sequence binary stream)
      (force-output stream))
    (loop :for b := (read-byte stream)
       :collecting b :into v
       :until (char= (code-char b) #\newline)
       :finally
       (write-byte (char-code #\0) stream)
       (let* ((r (coerce v '(vector (unsigned-byte 8))))
	      (s (octets-to-string r :encoding (encoding-of d))))
	 (return (rest (split "/" s)))))))
```		
