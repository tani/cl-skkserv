    (in-package :cl-skkserv/core)
    (in-readtable :papyrus)

# プロセス

```lisp
(defun read-request (stream)
  (loop :for b := (read-byte stream)
        :for c := (code-char b)
        :when (char<= #\0 c #\5) :return
           (coerce 
            (ecase c
              ((#\0 #\2 #\3 #\5) (list b))
              ((#\1 #\4)
               (loop :for d := (read-byte stream)
                     :for e := (code-char d)
                     :collecting d :into s
                     :until (char= e #\space)
                     :finally (return (append (list b) s)))))
            '(vector (unsigned-byte 8)))))

(defun write-response (stream response)
  (write-sequence response stream)
  (force-output stream))
```

```lisp
(defun process (stream dictionary encoding)
  (loop :for request := (octets-to-string (read-request stream) :encoding encoding)
        :for (status response) := (multiple-value-list (handle request dictionary))
        :until (= status 0)
        :if (= status 5) :do
           (throw :exit 1)
        :else :do
           (write-response stream (string-to-octets response :encoding encoding))))
```