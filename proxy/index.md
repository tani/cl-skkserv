    (in-package :cl-user)
    (defpackage :cl-skkserv/proxy
      (:nicknames :skkserv/proxy)
      (:use :cl :usocket :babel :cl-ppcre :named-readtables :papyrus :cl-skkserv/core)
      (:export proxy-dictionary))
    (in-package :cl-skkserv/proxy)
    (in-readtable :papyrus)

# プロキシー辞書

```lisp
(defclass proxy-dictionary (dictioanry)
  ((address :initarg :address :reader address-of)
   (port :initarg :port :reader port-of)
   (encoding :initarg :encoding :reader encoding-of)))
```

```lisp
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
```

```lisp
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
```