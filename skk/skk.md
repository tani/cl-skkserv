    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 統合辞書

```lisp
(defclass skk-dictionary (skk-text-dictionary skk-numeric-dictionary skk-lisp-dictionary) ())
```