(in-package :cl)
(defpackage :lime/skk/text
  (:use :cl :cl-ppcre :alexandria
        :lime/core/dictionary
        :lime/skk/pattern
        :lime/skk/lisp
        :lime/skk/util)
  (:export skk-text-dictionary))
(in-package :lime/skk/text)

(defclass skk-text-dictionary (dictionary)
  ((filespec :initarg :filespec :reader filespec)
   (table :initarg :table :accessor table)))

(defmethod initialize-instance :after ((dict skk-text-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table dict) (make-table (filespec dict)))
  (maphash (lambda (key value)
             (setf (gethash key (table dict))
                   (remove-if (conjoin #'patternp #'lispp) value))
             (unless (gethash key (table dict))
               (remhash key (table dict))))
           (table dict)))

(defmethod lookup ((dict skk-text-dictionary) (word string))
  (gethash word (table dict) ""))
