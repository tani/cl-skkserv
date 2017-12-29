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

- [テキスト辞書](/index.html?source=skk/text.md)
- [数値辞書](/index.html?source=skk/numeric.md)
- [LISP辞書](/index.html?source=skk/lisp.md)
- [辞書読み込み](/index.html?source=skk/util.md)

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
