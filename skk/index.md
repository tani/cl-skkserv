    (in-package :cl-user)
    (defpackage :cl-skkserv/skk
      (:nicknames :skkserv/skk)
      (:use :cl :alexandria :cl-ppcre :esrap :babel :jp-numeral :named-readtables :papyrus :cl-skkserv/core)
      (:export skk-dictionary
              skk-text-dictionary
              skk-numeric-dictionary
              skk-lisp-dictionary))
    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 目次

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

- [テキスト辞書](/cl-skkserv/index.html?source=skk/text.md)
- [数値辞書](/cl-skkserv/index.html?source=skk/numeric.md)
- [LISP辞書](/cl-skkserv/index.html?source=skk/lisp.md)
- [辞書読み込み](/cl-skkserv/index.html?source=skk/util.md)

# SKK辞書

上記全ての辞書を継承した、つまりSKK辞書でいえばL辞書に相当するクラスとして`skk-dictionary`クラスを定義してあります。

## 使い方

以下の様に設定ファイル内で`*dictionary*`変数を上書きしてください。

    (setq *dictionary* (make-instance 'skk-dictionary :pathname #p"/path/to/dictionary")

なおクラス生成時には必ず辞書のパス名を指定してください。

## クラス

```lisp
(defclass skk-dictionary (skk-text-dictionary skk-numeric-dictionary skk-lisp-dictionary) ())
```
