    (in-package :cl-user)
    (defpackage cl-skkserv/core
      (:nicknames :skkserv/core :cl-skkserv :skkserv)
      (:use :cl :asdf :alexandria :esrap :babel :papyrus :named-readtables)
      (:export dictionary
               convert
               complete
               handle
               process
               write-response
               read-request))
    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# コア機能

クライアントと辞書との間を取り持つための機能群です。**辞書**と**要求を解釈するハンドラー**と**クライアントとの接続を管理するプロセス**の3つから構成されます。cl-skkservをCommonLispから操作する場合どのレイヤーからでも始めることができます。

## 目次

- [辞書](/cl-skkserv/index.html?source=core/dictionary.md)
- [ハンドラー](/cl-skkserv/index.html?source=core/handler.md)
- [プロセス](/cl-skkserv/index.html?source=core/process.md)



