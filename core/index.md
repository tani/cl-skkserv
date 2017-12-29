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

クライアントと辞書との間を取り持つための機能群です。**辞書**と**要求を解釈するハンドラー**と**クライアントとの接続を管理するプロセス**の3つから構成されます。cl-skkservをCommonLispから操作する場合どのレイヤーからでも始めることができます。

## 目次

- [辞書](/cl-skkserv/index.html?source=core/dictionary.md)
- [ハンドラー](/cl-skkserv/index.html?source=core/handler.md)
- [プロセス](/cl-skkserv/index.html?source=core/process.md)



