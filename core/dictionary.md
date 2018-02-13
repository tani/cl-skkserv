    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# 辞書

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

cl-skkservが辞書機能を呼び出すための抽象クラスです。
cl-skkservで呼び出される辞書は必ずこのクラスを継承している必要があります。
辞書クラスは複数の

```lisp
(defclass dictionary () ())
(defgeneric convert (dictionary word)
  (:method-combination append)
  (:method append ((d dictionary) (s string))))
(defgeneric complete (dictionary word)
  (:method-combination append)
  (:method append ((d dictionary) (s string))))
```

なお辞書クラスを作る際には、よく菱型継承が発生します。その際にスロット名が重複すると意図しない検索結果になることがあります。
例えば`skk-dictionary`クラスは、`skk-text-dictionary`と`skk-lisp-dictionary`と`skk-numeric-dictionary`の３つのクラスを継承しています。
これらはすべて`pathname`というスロットを持っているため、これらの内どれかが`skk-dictionary`からの呼び出しの際に内部で書き換わると他の親クラスのスロットの値も変わってしまします。
このようなことが起きない用にするためには、スロット名を固有のものにし非公開の読み込み専用関数を、好きな名前にすると良いでしょう。
