(in-package :cl-user)
(defpackage :cl-skkserv/test/core
  (:use :cl :flexi-streams :1am
        :cl-skkserv/core
        :cl-skkserv/skk))
(in-package :cl-skkserv/test/core)

(defparameter *dictionary* (make-instance 'skk-text-dictionary :pathname #p"./data/SKK-JISYO.L"))

(test test-handler
      (is (equalp (multiple-value-list (handle "1a " *dictionary*))
                  (list 1 (format nil "1/~{~A/~}~%" (convert *dictionary* "a")))))
      (is (equalp (multiple-value-list (handle "4a " *dictionary*))
                  (list 4 (format nil "1/~{~A/~}~%" (complete *dictionary* "a"))))))

(test test-read-request
      (is (with-input-from-sequence (stream (string-to-octets "1a "))
            (equalp (read-request stream) (string-to-octets "1a ")))))

(test test-write-response
      (is (equalp (string-to-octets (format nil "1/a/~%"))
                  (with-output-to-sequence (stream)
                    (write-response stream (string-to-octets (format nil "1/a/~%")))))))
