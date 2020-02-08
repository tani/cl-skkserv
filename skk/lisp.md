    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# LISP辞書

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

項目の候補をLISPで記述されてると見做して評価してその結果を候補とする辞書です。

## 使い方

以下の様に設定ファイル内で`*dictionary*`変数を上書きしてください。

    (setq *dictionary* (make-instance 'skk-lisp-dictionary :pathname #p"/path/to/dictionary")

なおクラス生成時には必ず辞書のパス名を指定してください。


## クラス

この辞書クラスは`skk-lisp-dictionary`を言うクラス名で宣言されており、パス名と辞書データの二つを保持します。


```lisp
(defclass skk-lisp-dictionary (dictionary)
  ((pathname :initarg :pathname :reader pathname-of)
   (table :accessor table-of)))
```

### 初期化

初期化時にはパス名から自動で辞書テーブルが生成されます。

```lisp
(defmethod initialize-instance :after ((d skk-lisp-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table-of d) (make-table (pathname-of d))))

```

### 変換機能

変換時に使われる関数をここで定義します。
現状では`concat`関数のみをサポートします。これはSKK-JISYO.Lで使われている関数全てです。

```lisp
(defun concat (&rest s) (format nil "~{~A~}" s))

```

辞書内の項目で次の関数に一致する項目だけをS式と見做して候補として評価して返します。

```lisp
(defun lispp (s) (scan "^\\(.*\\)$" s))
```

変換時に項目内の8進数表現でエスケープされている文字を通常の文字に変換します。
そのあとパッケージ名を`cl-skkserv/skk`に変更して評価します。
これは`eval`関数のパッケージが動的であるからこのような操作が必要になっています。
全ての候補を評価しその結果の列を返します。

```lisp
(defmethod convert append ((d skk-lisp-dictionary) (s string))
  (let* ((candidates (gethash s (table-of d)))
         (*package* (find-package :cl-skkserv/skk)))
    (labels ((octet-to-char-1 (matches digits)
               (declare (ignore matches))
               (princ-to-string (code-char (parse-integer digits :radix 8))))
             (octet-to-char (candidate)
               (regex-replace-all "\\\\0(\\d\\d)" candidate #'octet-to-char-1 :simple-calls t)))
      (mapcar (compose #'eval #'read-from-string #'octet-to-char)
	      (remove-if-not #'lispp candidates)))))
```

### 補完機能

補完候補はハッシュテーブルの項目名から生成されます。

```lisp
(defmethod complete append ((d skk-lisp-dictionary) (s string))
  (loop :for key :being :the :hash-keys :of (table-of d)
        :when (scan (format nil "^~a" s) key) :collect key))
```
