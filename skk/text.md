    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# テキスト辞書

```lisp
(defclass skk-text-dictionary (dictionary)
  ((skk-text-dictionary-pathname :initarg :pathname :reader skk-text-dictionary-pathname)
   (skk-text-dictionary-table :accessor skk-text-dictionary-table)))
```

```lisp
(defmethod initialize-instance :after ((dict skk-text-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (skk-text-dictionary-table dict) (make-table (skk-text-dictionary-pathname dict)))
  (maphash (lambda (key value)
             (setf (gethash key (skk-text-dictionary-table dict))
                   (remove-if (disjoin #'numericp #'lispp) value))
             (unless (gethash key (skk-text-dictionary-table dict))
               (remhash key (skk-text-dictionary-table dict))))
           (skk-text-dictionary-table dict)))
```

```lisp
(defmethod convert append ((d skk-text-dictionary) (s string))
  (gethash s (skk-text-dictionary-table d)))
```

```lisp
(defmethod complete append ((d skk-text-dictionary) (s string))
  (loop :for key :being :the :hash-keys :of (skk-text-dictionary-table d)
        :when (scan (format nil "^~a" s) key) :collect key))
```