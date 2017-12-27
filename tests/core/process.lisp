(in-package :cl-user)
(defpackage :cl-skkserv/tests/core/process
  (:use :cl :flexi-streams :1am 
        :cl-skkserv/core/process))
(in-package :cl-skkserv/tests/core/process)

(test test-read-request
      (is (with-input-from-sequence (stream (string-to-octets "1a "))
            (equalp (read-request stream) (string-to-octets "1a ")))))

(test test-write-response
      (is (equalp (string-to-octets (format nil "1/a/~%"))
                  (with-output-to-sequence (stream)
                    (write-response stream (string-to-octets (format nil "1/a/~%")))))))
