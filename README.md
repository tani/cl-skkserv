<div style="text-align: center">
	<img src="https://openclipart.org/image/2400px/svg_to_png/273616/Lime.png" height="100px"/> <br>
	<img src="https://img.shields.io/badge/amazon-wishlist-orange.svg" />
	<h1>LIME<br><small>Lisp Input Method Editor</small></h1>
</div>

## 概要

LIME はSKKに影響を受けた日本語入力システムです。

既存のSKKサーバーとの互換性を保ちながらCommon Lispによるインテグレーションを可能にします。

LIMEはSKKサーバーとその辞書機能が完全に分離しており動的に辞書機能を書き換えることが可能です。
これにより辞書ファイルを事前に合成しておく必要がなくなります。
更にGoogleのCGIや他のSKKサーバーでさえ辞書として使うことができます。

## 導入
Common Lisp開発ツールであるRoswellを使うことで以下のように簡単に導入できます。

    $ ros install asciian/lime

## 使い方

### 基本的な使い方

    $ lime up
    $ lime down

### 応用的な使い方

#### 設定

`~/.limerc`で編集することができます。以下に一例を示します。

```lisp
(in-package :cl)
(defpackage :limerc
  (:use :cl :lime))
(in-package :limerc)

(setf *dictionary* (make-instance 'skk-dictionary :filespec #p"/path/to/dictionary"))
```


#### 辞書

すべての辞書はCLOSによって管理されており、必ずDICTIONARYクラスを継承しLOOKUPメソッドが定義されています。
もしあなたが新しい辞書を作りたい場合はDICTIONARYクラスを継承しLOOKUPメソッドを定義したクラスを作ることで辞書を作ることができます。

以下は入力をそのまま候補として返すEcho辞書の例です。
メソッドコンビネーションがlistになっていることに注意してください。
```lisp
(defclass echo-dictionary (dictionary) ())
(defmethod lookup append ((d echo-dictionary) (s string)) (declare (ignore d)) (list s))
(setf *dictionary* (make-instance 'echo-dictionary))
```

例えば、SKKの辞書にEcho辞書を合成したいならSKK辞書を継承して以下のようにすることができます。

```lisp
(defclass echo-and-skk-dictionary (echo-dictionary skk-dictionary) ()) ;; skk-dicitonary はdictionaryクラスのサブクラスです。
(setf *dictionary* (make-instance 'echo-and-skk-dictionary :filespec #p"/path/to/dictionary"))
```

また、DICTIONARYクラスのサブクラスのインスタンス同士を合成するMIXED-DICTIONARYクラスを使うこともできます。

```lisp
(defvar skk (make-instance 'skk-dictionary :filespec #p"/path/to/dictionary"))
(defvar echo (make-instance 'echo-dictionary))
(setf *dictionary* (make-instance 'mixed-dictionary :dictionaries (list skk echo)))
```

LIMEで既に定義されている辞書としては以下のクラスがあります。

- dictionary
    - skk-text-dictionary
        - skk-dictionary [1]
    - skk-lisp-dictionary
        - skk-dictionary [1]
    - skk-pattern-dictionary [2]
        - skk-lisp-dictionary [1]
    - google-input-method-dictionary [3]
    - mixed-dictionary
    - proxy-dictionary [4]

1. skk-dictionaryはskk-text-dictionaryとskk-lisp-dictionaryとskk-lisp-dictionaryの３つを継承したクラスです
2. 対応している数値変換は無変換(#0)と全角(#1)と漢数字(#2 #3 #5)です
3. Google日本語入力を用いた変換を行うクラスです
4. proxy-dictionaryは他のSKKサーバーと通信するためのクラスです

## ライセンス
GPL第三版及びそれ以降のライセンスのもとで公開された自由ソフトウェアです。

## 著作権表示
Copyright (c) 2017 asciian ALL Rights Reserved.
