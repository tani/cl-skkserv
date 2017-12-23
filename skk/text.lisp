(in-package :cl)
(defpackage :lime/skk/text
  (:use :cl :cl-ppcre :lime/skk/util :lime/core/dictionary)
  (:export skk-text-dictionary))
(in-package :lime/skk/text)

(defclass skk-text-dictionary (dictionary)
  ((filespec :initarg :filespec :reader filespec)
   (table :initarg :table :accessor table)))

(defmethod initialize-instance :after ((dict skk-text-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table dict) (make-table (filespec dict))))

(defmethod lookup ((dict skk-text-dictionary) (word string))
  (gethash word (table dict) ""))
