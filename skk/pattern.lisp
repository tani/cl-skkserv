(in-package :cl)
(defpackage :lime/skk/pattern
  (:use :cl :esrap :cl-ppcre :alexandria
        :lime/core/dictionary
        :lime/skk/lisp
        :lime/skk/util)
  (:export skk-pattern-dictionary patternp))
(in-package :lime/skk/pattern)

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

(defclass skk-pattern-dictionary (dictionary)
  ((filespec :initarg :filespec :reader filespec)
   (table :initarg :table :accessor table)))

(defun patternp (s) (scan "#" s))

(defmethod initialize-instance :after ((dict skk-pattern-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (table dict) (make-table (filespec dict)))
  (maphash (lambda (key value)
             (setf (gethash key (table dict))
                   (remove-if-not (conjoin #'patternp (compose #'not #'lispp)) value))
             (unless (gethash key (table dict))
               (remhash key (table dict))))
           (table dict)))

(defmethod lookup ((d skk-pattern-dictionary) (s string))
  (let* ((arguments (parse '(+ (or digits non-digits)) s))
         (masked (regex-replace-all "[0-9]+" s "#"))
	 (candidates (gethash masked (table d))))
    (flet ((make-candidate (candidate)
             (let ((functions (parse '(+ (or placeholder non-placeholder)) candidate)))
               (format nil "~{~A~}" (mapcar #'funcall functions (append arguments '(nil)))))))
      (mapcar #'make-candidate candidates))))
