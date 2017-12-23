(in-package :cl)
(defpackage :lime/skk/lisp
  (:use :cl :cl-ppcre :esrap :alexandria
        :lime/core/dictionary
        :lime/skk/util)
  (:export skk-lisp-dictionary lispp))
(in-package :lime/skk/lisp)

(defclass skk-lisp-dictionary (dictionary)
  ((filespec :initarg :filespec :reader filespec)
   (table :initarg :table :accessor table)))

(defun lispp (s) (scan "^\\(.*\\)$" s))

(defmethod initialize-instance :after ((dict skk-lisp-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table dict) (make-table (filespec dict)))
  (maphash (lambda (key value)
             (setf (gethash key (table dict))
                   (remove-if-not #'lispp value))
             (unless (gethash key (table dict))
               (remhash key (table dict))))
           (table dict)))

(defun concat (&rest s) (format nil "~{~A~}" s))

(defmethod lookup ((dict skk-lisp-dictionary) (word string))
  (let* ((candidates (gethash word (table dict) ""))
         (*package* (find-package :lime/skk/lisp)))
    (labels ((octet-to-char-1 (matches digits)
               (declare (ignore matches))
               (princ-to-string (code-char (parse-integer digits :radix 8))))
             (octet-to-char (candidate)
               (regex-replace-all "\\\\0(\\d\\d)" candidate #'octet-to-char-1 :simple-calls t)))
      (mapcar (compose #'eval #'read-from-string #'octet-to-char) candidates))))
