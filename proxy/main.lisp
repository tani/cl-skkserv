(in-package :cl-user)
(defpackage :lime/proxy/main
  (:nicknames :lime/proxy)
  (:use :cl :usocket :babel :cl-ppcre)
  (:import-from :lime/core/main dictionary convert complete)
  (:export proxy-dictionary))
(in-package :lime/proxy/main)

(defclass proxy-dictionary (dictioanry)
  ((address :initarg :address :reader address-of)
   (port :initarg :port :reader port-of)
   (encoding :initarg :encoding :reader encoding-of)))

(defmethod convert append ((d proxy-dictionary) (s string))
  (with-client-socket (socket stream (address-of d) (port-of d))
    (let* ((request (format nil "1~a " s))
           (binary (string-to-octets request :encoding (encoding-of d))))
      (write-sequence binary stream)
      (force-output stream))
    (loop :for b := (read-byte stream)
          :collecting b :into v
          :until (char= (code-char b) #\newline)
          :finally
             (let* ((r (coerce v '(vector (unsigned-byte 8))))
                    (s (octets-to-string r :encoding (encoding-of d))))
               (return (split "/" s))))))

(defmethod complete append ((d proxy-dictionary) (s string))
  (with-client-socket (socket stream (address-of d) (port-of d))
    (let* ((request (format nil "4~a " s))
           (binary (string-to-octets request :encoding (encoding-of d))))
      (write-sequence binary stream)
      (force-output stream))
    (loop :for b := (read-byte stream)
          :collecting b :into v
          :until (char= (code-char b) #\newline)
          :finally
             (let* ((r (coerce v '(vector (unsigned-byte 8))))
                    (s (octets-to-string r :encoding (encoding-of d))))
               (return (split "/" s))))))


