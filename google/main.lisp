(in-package :cl-user)
(defpackage :lime/google
  (:use :cl :drakma :yason :flexi-streams :alexandria)
  (:import-from :lime/core/main dictionary convert)
  (:export google-input-method-dictionary))
(in-package :lime/google)

(defparameter *URL* "http://www.google.com/transliterate")

(defclass google-input-method-dictionary (dictionary) ())

(defmethod convert append ((d google-input-method-dictionary) (s string))
  (let* ((*drakma-default-external-format* :utf-8)
         (params `(("langpair" . "ja-Hira|ja") ("text" . ,s)))
         (stream (http-request *URL* :parameters params)))
    (setf (flexi-stream-external-format stream) :utf-8)
    (let ((candidates (mapcar #'second (parse stream :object-as :plist))))
      (flet ((scat (&rest s) (apply concatenate 'string s)))
        (apply #'map-product #'scat candidates)))))

