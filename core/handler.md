    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# ハンドラー

```lisp
(defrule convert-request (and #\1 (+ (not #\space)) #\space)
  (:lambda (list) (list (parse-integer (first list)) (format nil "~{~a~}" (second list)))))

(defrule complete-request (and #\4 (+ (not #\space)) #\space)
  (:lambda (list) (list (parse-integer (first list)) (format nil "~{~a~}" (second list)))))

(defrule other-request (or #\0 #\2 #\3 #\5)
  (:lambda (list) (list (parse-integer list))))
  
(defrule request (or convert-request
                     complete-request
                     other-request))
```

```lisp
(defun handle (string dictionary)
  ;; http://umiushi.org/~wac/yaskkserv/#protocol
  (let ((request (parse 'request string)))
    (values
     (first request)
     (case (first request)
       (1 (let ((result (convert dictionary (second request))))
            (format nil "~A/~{~A/~}~%" (if result 1 4) result)))
       (2 (format nil "~a " (component-version (find-system :cl-skkserv))))
       (3 (format nil "hostname:addr:...: "))
       (4 (let ((result (complete dictionary (second request))))
            (format nil "1/~{~A/~}~%" result)))))))
```