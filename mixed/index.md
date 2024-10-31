    (defpackage :cl-skkserv/mixed
      (:nicknames :skkserv/mixed)
      (:use :cl :cl-skkserv/core)
      (:export :mixed-dictionary))
    (in-package :cl-skkserv/mixed)
    (named-readtables:in-readtable papyrus:md-syntax)

# 複合辞書

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

複数の辞書クラスの**インスタンス**を使うための辞書です。

## 使い方

以下の様に設定ファイル内で`*dictionary*`変数を上書きしてください。

    (setq *dictionary* (make-instance 'mixed-dictionary :dictionaries (list dictionary1 dictionary2)))


## クラス

この辞書は複数の辞書クラスのインスタンスの列を`dictionaries`スロットとして持ちます。

```lisp
(defclass mixed-dictionary (dictionary)
  ((dictionaries :initarg :dictionaries :reader dictionaries)))
```

### 変換機能

変換機能は各辞書に対して変換機能を実行したときの結果をスロット内の列の順で結合したものになります。

```lisp
(defmethod convert append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (convert d s)) (dictionaries d))))
```

### 補完機能

補完機能は各辞書に対して補完機能を実行したときの結果をスロット内の列の順で結合したものになります。

```lisp
(defmethod complete append ((d mixed-dictionary) (s string))
  (apply #'append (mapcar (lambda (d) (complete d s)) (dictionaries d))))
```

## 端書

辞書の結合には以下のようなクラスの継承を用いた方法をお勧めします。


    (defclass new-dictionary (old-dictionary-1 old-dictionary-2))
    (make-instance 'new-dictionary)


なぜなら`mixed-dictionary`を使って作られた辞書同士の結合は、また`mixed-dictionary`でしか出来ないからです。一方でクラス継承を使用したときは、クラス継承と`mixed-dictionary`の二つの方法で結合できるようになります。

