    (in-package :cl-skkserv/skk)
    (in-readtable :papyrus)

# 辞書の読み込み

```lisp
(defrule value (+ (not #\/))
  (:lambda (list) (coerce list 'string)))
(defrule key (+ (not #\space))
  (:lambda (list) (coerce list 'string)))
(defrule comment (and #\; (* (not #\newline)))
  (:lambda (list) (declare (ignore list)) nil))
(defrule record (and key #\space #\/ (+ (and value #\/)))
  (:lambda (list) (cons (first list) (mapcar #'car (fourth list)))))
```

```lisp
(defun remove-comment (s)
  (regex-replace ";.*$" s ""))
```

```lisp
(defun make-table (pathname)
  (let* ((octets (read-file-into-byte-vector pathname))
         (string (babel:octets-to-string octets :encoding :eucjp)))
    (with-input-from-string (stream string)
      (do* ((table (make-hash-table :test 'equalp))
            (line (read-line stream nil nil nil)
                  (read-line stream nil nil nil))
            (record (and line (parse '(or comment record) line))
                    (and line (parse '(or comment record) line))))
          ((not line) table)
        (unless (null record)
          (setf (gethash (first record) table) 
                (mapcar #'remove-comment (rest record))))))))
```