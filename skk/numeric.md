    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 数値辞書

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

数値辞書はSKK辞書にある`#`で始まる文字列を変換元の数値に置き換える辞書です。

## 使い方

以下の様に設定ファイル内で`*dictionary*`変数を上書きしてください。

    (setq *dictionary* (make-instance 'skk-numeric-dictionary :pathname #p"/path/to/dictionary")

なおクラス生成時には必ず辞書のパス名を指定してください。


## 構文

項目中に`#[0-9]?`に一致する時、それを以下のルールに従って置換します。

| 対象文字列 | 効果 |
| --------- | --- |
| #         | 変換なし |
| #0        | 変換なし |
| #1        | 数値を全角に変換 |
| #2        | 漢数字(位取りあり)に変換 |
| #3        | 漢数字(位取りなし)に変換 |
| #4        | 置換後再検索(未サポート) |
| #5        | 漢数字(位取りなし・大字)に変換 |
| #9        | 棋譜に変換 (未サポート) |

例えば、「10ばんめ」という文字列で項目が「#ばんめ /#番目/#1番目/#2番目/#3番目/#5番目/」の場合は、`("10番目" "１０番目" "一〇番目" "十番目" "拾番目")`となります。

```lisp
(defun hankaku-to-zenkaku (s)
  (flet ((hankaku-to-zenkaku-1 (c)
           (princ-to-string
            (char "０１２３４５６７８９" (parse-integer c)))))
    (regex-replace-all "\\d" s #'hankaku-to-zenkaku-1 :simple-calls t)))

(defrule placeholder (and #\# (? (character-ranges (#\0 #\9))))
  (:lambda (list)
    ;; http://www.quruli.ivory.ne.jp/document/ddskk_14.2/skk_4.html#g_t_00e6_0095_00b0_00e5_0080_00a4_00e5_00a4_0089_00e6_008f_009b
    (case (second list)
      ((#\0 nil) #'identity)
      (#\1 (lambda (n) (hankaku-to-zenkaku n)))
      (#\2 (lambda (n) (format nil "~@:/jp-numeral:jp/" (parse-integer n))))
      (#\3 (lambda (n) (format nil "~/jp-numeral:jp/" (parse-integer n))))
      (#\4 (lambda (n) n))
      (#\5 (lambda (n) (format nil "~:/jp-numeral:jp/" (parse-integer n))))
      (#\9 (lambda (n) n)))))

(defrule non-placeholder (+ (not placeholder))
  (:lambda (list) (constantly (format nil "~{~a~}" list))))

(defrule digits (+ (character-ranges (#\0 #\9))) (:text t))

(defrule non-digits (+ (not (character-ranges (#\0 #\9)))) (:text t))
```

## クラス

この辞書クラスは`skk-numeric-dictionary`を言うクラス名で宣言されており、パス名と辞書データの二つを保持します。

```lisp
(defclass skk-numeric-dictionary (dictionary)
  ((pathname :initarg :pathname :reader pathname-of)
   (table :accessor table-of)))
```

### 初期化

初期化時にはパス名から自動で辞書テーブルが生成されます。

```lisp
(defmethod initialize-instance :after ((d skk-numeric-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table-of d) (make-table (pathname-of d))))
```


### 変換機能

辞書内の項目で次の関数に一致する項目だけを数値項目と見做して候補として置換をおこないます。

```lisp
(defun numericp (s) (scan "#" s))
```

全ての候補を評価しその結果の列を返します。
例えば「10ばんめ」という文字列で項目が「#ばんめ /#番目/#1番目/#2番目/#3番目/#5番目/」の場合は、`("10番目" "１０番目" "一〇番目" "十番目" "拾番目")`となります。

```lisp
(defmethod convert append ((d skk-numeric-dictionary) (s string))
  (let* ((arguments (parse '(+ (or digits non-digits)) s))
         (masked (regex-replace-all "[0-9]+" s "#"))
         (candidates (gethash masked (table-of d))))
    (flet ((make-candidate (candidate)
             (let ((functions (parse '(+ (or placeholder non-placeholder)) candidate)))
               (format nil "~{~A~}" (mapcar #'funcall functions (append arguments '(nil)))))))
      (mapcar #'make-candidate (remove-if-not #'numericp candidates)))))
```

### 補完機能

補完機能はありません。
