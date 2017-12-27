    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# LISP辞書

```lisp
(defclass skk-lisp-dictionary (dictionary)
  ((skk-lisp-dictionary-pathname :initarg :pathname :reader skk-lisp-dictionary-pathname)
   (skk-lisp-dictionary-table :accessor skk-lisp-dictionary-table)))
```

```lisp
(defun lispp (s) (scan "^\\(.*\\)$" s))
```

```lisp
(defmethod initialize-instance :after ((d skk-lisp-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (skk-lisp-dictionary-table d) (make-table (skk-lisp-dictionary-pathname d)))
  (maphash (lambda (key value)
             (setf (gethash key (skk-lisp-dictionary-table d))
                   (remove-if-not #'lispp value))
             (unless (gethash key (skk-lisp-dictionary-table d))
               (remhash key (skk-lisp-dictionary-table d))))
           (skk-lisp-dictionary-table d)))
```

```lisp
(defun concat (&rest s) (format nil "~{~A~}" s))
```

```lisp
(defmethod convert append ((d skk-lisp-dictionary) (s string))
  (let* ((candidates (gethash s (skk-lisp-dictionary-table d)))
         (*package* (find-package :cl-skkserv/skk)))
    (labels ((octet-to-char-1 (matches digits)
               (declare (ignore matches))
               (princ-to-string (code-char (parse-integer digits :radix 8))))
             (octet-to-char (candidate)
               (regex-replace-all "\\\\0(\\d\\d)" candidate #'octet-to-char-1 :simple-calls t)))
      (mapcar (compose #'eval #'read-from-string #'octet-to-char) candidates))))
```

```lisp
(defmethod complete append ((d skk-lisp-dictionary) (s string))
  (loop :for key :being :the :hash-keys :of (skk-lisp-dictionary-table d)
        :when (scan (format nil "^~a" s) key) :collect key))
```