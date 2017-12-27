    (in-package :cl-user)
    (defpackage :cl-skkserv/google
      (:nicknames :skkserv/google)
      (:use :cl :drakma :yason :flexi-streams :alexandria :named-readtables :papyrus :cl-skkserv/core)
      (:export google-input-method-dictionary))
    (in-package :cl-skkserv/google)
    (in-readtable :papyrus)

# Google日本語入力API辞書

```lisp
(defparameter *URL* "http://www.google.com/transliterate")
```

```lisp
(defclass google-input-method-dictionary (dictionary) ())
```

```lisp
(defmethod convert append ((d google-input-method-dictionary) (s string))
  (let* ((*drakma-default-external-format* :utf-8)
         (params `(("langpair" . "ja-Hira|ja") ("text" . ,s)))
         (stream (http-request *URL* :parameters params)))
    (setf (flexi-stream-external-format stream) :utf-8)
    (let ((candidates (mapcar #'second (parse stream :object-as :plist))))
      (flet ((scat (&rest s) (apply #'concatenate 'string s)))
        (apply #'map-product #'scat candidates)))))
```
