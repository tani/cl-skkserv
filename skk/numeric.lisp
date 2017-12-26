(in-package :cl-user)
(defpackage :lime/skk/numeric
  (:use :cl :esrap :cl-ppcre :alexandria)
  (:import-from :lime/core/main dictionary convert)
  (:import-from :lime/skk/lisp lispp)
  (:import-from :lime/skk/util make-table)
  (:export skk-numeric-dictionary numericp))
(in-package :lime/skk/numeric)

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

(defclass skk-numeric-dictionary (dictionary)
  ((skk-numeric-dictionary-pathname :initarg :pathname :reader skk-numeric-dictionary-pathname)
   (skk-numeric-dictionary-table :accessor skk-numeric-dictionary-table)))

(defun numericp (s) (scan "#" s))

(defmethod initialize-instance :after ((d skk-numeric-dictionary) &rest initargs)
  (declare (ignore initargs))
  (setf (skk-numeric-dictionary-table d) (make-table (skk-numeric-dictionary-pathname d)))
  (maphash (lambda (key value)
             (setf (gethash key (skk-numeric-dictionary-table d))
                   (remove-if-not (conjoin #'numericp (compose #'not #'lispp)) value))
             (unless (gethash key (skk-numeric-dictionary-table d))
               (remhash key (skk-numeric-dictionary-table d))))
           (skk-numeric-dictionary-table d)))

(defmethod convert append ((d skk-numeric-dictionary) (s string))
  (let* ((arguments (parse '(+ (or digits non-digits)) s))
         (masked (regex-replace-all "[0-9]+" s "#"))
         (candidates (gethash masked (skk-numeric-dictionary-table d))))
    (flet ((make-candidate (candidate)
             (let ((functions (parse '(+ (or placeholder non-placeholder)) candidate)))
               (format nil "~{~A~}" (mapcar #'funcall functions (append arguments '(nil)))))))
      (mapcar #'make-candidate candidates))))
