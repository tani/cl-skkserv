# cl-skkserv
[![GitHub](https://img.shields.io/badge/Hosted%20with-GitHub-red.svg)](https://github.com/bibliobibulus/cl-skkserv/) [![Quicklisp](http://quickdocs.org/badge/cl-skkserv.svg)](http://quickdocs.org/cl-skkserv/)

## 概要

cl-skkserv はSKKに影響を受けた日本語入力システムです。
既存のSKKサーバーとの互換性を保ちながらCommon Lispによるインテグレーションを可能にします。

cl-skkservはSKKサーバーとその辞書機能が完全に分離しており動的に辞書機能を書き換えることが可能です。
これにより辞書ファイルを事前に合成しておく必要がなくなります。
更にGoogleのCGIや他のSKKサーバーでさえ辞書として使うことができます。

## 導入

Common Lisp開発ツールであるRoswellを使うことで以下のように簡単に導入できます。

    $ ros install cl-skkservl # 安定版 (Quicklisp)
	$ ros install tani/cl-skkserv # 開発版 (Nightly)

## 使い方

### 基礎

    $ skkserv start # skkservを起動する
    $ skkserv stop  # skkservを停止する

### 応用

#### 設定

`~/.skkservrc`で編集することができます。以下に一例を示します。

```lisp
(in-package :skkserv-user)

(setf *dictionary* (make-instance 'skk-dictionary :pathname #p"/path/to/dictionary"))
```
##### Emacs

Emacsで使う場合は`~/.emacs`で以下を追記してください。

```
(setq skk-server-host "127.0.0.1")
(setq skk-server-portnum 1178)
```

##### Vim

Vimで使う場合は`~/.vimrc`で以下を追記してください。
```
let g:eskk#server = {
\	'host': 'localhost',
\	'port': 1178,
\}
```

#### 辞書

すべての辞書はCLOSによって管理されており、必ずDICTIONARYクラスを継承しconvertメソッドが定義されています。
もしあなたが新しい辞書を作りたい場合はDICTIONARYクラスを継承しconvertメソッドを定義したクラスを作ることで辞書を作ることができます。

以下は入力をそのまま候補として返すEcho辞書の例です。
メソッドコンビネーションがappendになっていることに注意してください。

```lisp
(defclass echo-dictionary (dictionary) ())
(defmethod convert append ((d echo-dictionary) (s string)) (declare (ignore d)) (list s))
(setq *dictionary* (make-instance 'echo-dictionary))
```

例えば、SKKの辞書にEcho辞書を合成したいならSKK辞書を継承して以下のようにすることができます。

```lisp
(defclass echo-and-skk-dictionary (echo-dictionary skk-dictionary) ()) ;; skk-dicitonary はdictionaryクラスのサブクラスです。
(setq *dictionary* (make-instance 'echo-and-skk-dictionary :pathname #p"/path/to/dictionary"))
```

また、DICTIONARYクラスのサブクラスのインスタンス同士を合成するMIXED-DICTIONARYクラスを使うこともできます。

```lisp
(defvar skk (make-instance 'skk-dictionary :pathname #p"/path/to/dictionary"))
(defvar echo (make-instance 'echo-dictionary))
(setq *dictionary* (make-instance 'mixed-dictionary :dictionaries (list skk echo)))
```

cl-skkservで既に定義されている辞書としては以下のクラスがあります。

- dictionary
    - skk-text-dictionary
        - skk-dictionary
    - skk-lisp-dictionary
        - skk-dictionary
    - skk-pattern-dictionary
        - skk-dictionary
    - google-ime-dictionary
    - mixed-dictionary
    - proxy-dictionary

## リファレンス

各システムは[Papyrus](https://github.com/tani/papyrus/)によって文芸的プログラミングで作られています。
各ページへの目次は以下の通りです。

- [ルート](https://tani.github.io/cl-skkserv/index.html)
    - [コア機能](https://tani.github.io/cl-skkserv/index.html?source=core/index.md)
    - [SKK辞書](https://tani.github.io/cl-skkserv/index.html?source=skk/index.md)
    - [Google日本語入力辞書](https://tani.github.io/cl-skkserv/index.html?source=google-ime/index.md)
    - [プロキシー辞書](https://tani.github.io/cl-skkserv/index.html?source=proxy/index.md)
    - [複合辞書](https://tani.github.io/cl-skkserv/index.html?source=mixed/index.md)
    - [設定ファイル](https://tani.github.io/cl-skkserv/index.html?source=user/index.md)

## ライセンス

GPL第三版及びそれ以降のライセンスのもとで公開された自由ソフトウェアです。
ライセンスドキュメントは[こちら](https://tani.github.io/cl-skkserv/index.html?source=LICENSE.md)。

## 著作権表示

Copyright (c) 2017 TANIGUCHI Masaya ALL Rights Reserved.
