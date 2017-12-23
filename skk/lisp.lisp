(in-package :cl)
(defpackage :lime/skk/lisp
  (:use :cl :cl-ppcre :lime/core/dictionary :lime/skk/util)
  (:export skk-lisp-dictionary))
(in-package :lime/skk/lisp)

(defclass skk-lisp-dictionary (dictionary)
  ((filespec :initarg :filespec :reader filespec)
   (table :initarg :table :accessor table)))

(defmethod initialize-instance :after ((dict skk-lisp-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table dict) (make-table (filespec dict))))

(defmethod lookup ((dict skk-lisp-dictionary) (word string))
  (let ((candidates (gethash word (table dict) "")))
    (mapcar (lambda (candidate)
              (if (ppcre:scan "^\\(.+\\)$" candidate)
                  (eval (read-from-string candidate))
                  candidate))
            candidates)))
