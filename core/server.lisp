(in-package :cl)
(defpackage :lime/core/server
  (:use :cl :usocket :esrap :asdf
        :lime/core/dictionary)
  (:export server-start
           server-stop))
(in-package :lime/core/server)

(defrule disconnect-request #\0
  (:lambda (char) (list char)))
(defrule convert-request (and #\1 (+ (not #\space)) #\space)
  (:lambda (list) (list (first list) (format nil "~{~a~}" (second list)))))
(defrule version-request #\2
  (:lambda (char) (list char)))
(defrule name-request #\3
  (:lambda (char) (list char)))
(defrule completion-request (and #\4 (+ (not #\space)) #\space)
  (:lambda (list) (list (first list) (format nil "~{~a~}" (second list)))))
(defrule request (or disconnect-request
                     convert-request
                     version-request
                     name-request
                     completion-request))

(defmacro with-socket-stream ((stream connection) &body body)
  `(let ((,stream (socket-stream ,connection)))
     (unwind-protect (progn ,@body) (close ,stream))))

(defun chomp (s)
  (let ((end (or (position (code-char 13) s)
                 (position (code-char 10) s))))
    (if end (subseq s 0 end) s)))

(defun server-start (&key address port dictionary)
  (with-socket-listener (socket address port)
    (with-server-socket (connection (socket-accept socket))
      (with-socket-stream (stream connection)
        (loop :named loop
              :for line := (read-line stream nil) :while line
              :for request := (parse 'request (chomp line)) :do
                 (case (parse-integer (first request))
                   (0 (return-from loop))
                   (1 (let ((candidates (lookup dictionary (second request))))
                        (format stream "1/~{~A/~}~%" candidates)))
                   (2 (fomrat stream "~a" (component-version (find-system :lime))))
                   (3 (format stream "~a:~a" address port))
                   (4 (let ((candidates (lookup dictionary (second request))))
                        (format stream "4/~{~A/~}~%" candidates)))
                   (else (return-from loop)))
                 (force-output stream))))))

(defun server-stop ())
