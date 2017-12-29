SHELL=/bin/bash

all:

.PHONY: test clean format http

test:
	./roswell/skkserv.ros start --no-init --port=2278
	ros run -e '(asdf:test-system :cl-skkserv)' -q
	./roswell/skkserv.ros stop --no-init --port=2278

clean:
	find . -name '*~' | xargs rm

format:
	find . -name '*.lisp' | xargs gsed -i -e 's/\t/    /g'
	find . -name '*.lisp' | xargs ros fmt

http:
	clackup <(echo "(lack:builder (:static :path #'identity) #'identity)")
