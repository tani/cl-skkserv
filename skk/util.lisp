(in-package :cl)
(defpackage :lime/skk/util
  (:use :cl :babel :alexandria :esrap :cl-ppcre)
  (:export make-table))
(in-package :lime/skk/util)

(defrule value (+ (not #\/))
  (:lambda (list) (coerce list 'string)))
(defrule key (+ (not #\space))
  (:lambda (list) (coerce list 'string)))
(defrule comment (and #\; (* (not #\newline)))
  (:lambda (list) (declare (ignore list)) nil))
(defrule record (and key #\space #\/ (+ (and value #\/)))
  (:lambda (list) (cons (first list) (mapcar #'car (fourth list)))))

(defun remove-comment (s)
  (regex-replace ";.*$" s ""))

(defun make-table (filespec)
  "create hash-table from SKK-JISYO"
  (let* ((octets (read-file-into-byte-vector filespec))
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

