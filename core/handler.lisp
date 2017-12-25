(in-package :cl)
(defpackage :lime/core/handler
  (:use :cl :esrap :asdf)
  (:import-from :lime/core/dictionary convert complete)
  (:export handler))
(in-package :lime/core/handler)

(defrule disconnect-request #\0
  (:lambda (char) (list char)))
(defrule convert-request (and #\1 (+ (not #\space)) #\space)
  (:lambda (list) (list (first list) (format nil "~{~a~}" (second list)))))
(defrule version-request #\2
  (:lambda (char) (list char)))
(defrule name-request #\3
  (:lambda (char) (list char)))
(defrule complete-request (and #\4 (+ (not #\space)) #\space)
  (:lambda (list) (list (first list) (format nil "~{~a~}" (second list)))))
(defrule exit-request #\5
  (:lambda (char) (list char)))
(defrule request (or disconnect-request
                     convert-request
                     version-request
                     name-request
                     complete-request
                     exit-request))

(defun chomp (s)
  (let ((end (or (position (code-char 13) s)
                 (position (code-char 10) s))))
    (if end (subseq s 0 end) s)))

(defun handler (stream dictionary)
  ;; http://umiushi.org/~wac/yaskkserv/#protocol
  (let* ((line (read-line stream))
         (request (parse 'request (chomp line))))
    (case (parse-integer (first request))
      (0 (return-from handler t))
      (1 (format stream "1/~{~A/~} " (convert dictionary (second request))))
      (2 (format stream "~a " (component-version (find-system :lime))))
      (3 (format stream "hostname:addr:...: "))
      (4 (format stream "4/~{~A/~}~%" (complete dictionary (second request))))
      (t (throw :exit 1)))
    (force-output stream)
    (return-from handler nil)))
