    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# 辞書

cl-skkservが辞書機能を呼び出すための抽象クラスです。
cl-skkservで呼び出される辞書は必ずこのクラスを継承している必要があります。
辞書クラスは複数の

```lisp
(defclass dictionary () ())
(defgeneric convert (dictionary word)
  (:method-combination append))
(defgeneric complete (dictionary word)
  (:method-combination append))
```

なお辞書クラスを作る際には、よく菱型継承が発生します。その際にスロット名が重複すると意図しない検索結果になることがあります。
例えば`skk-dictionary`クラスは、`skk-text-dictionary`と`skk-lisp-dictionary`と`skk-numeric-dictionary`の３つのクラスを継承しています。
これらはすべて`pathname`というスロットを持っているため、これらの内どれかが`skk-dictionary`からの呼び出しの際に内部で書き換わると他の親クラスのスロットの値も変わってしまします。
このようなことが起きない用にするためには、スロット名を固有のものにし非公開の読み込み専用関数を、好きな名前にすると良いでしょう。
