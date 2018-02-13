SHELL=/bin/bash
DEPS=alexandria cl-ppcre esrap 1am portable-threads jp-numeral drakma flexi-streams yason papyrus named-readtables babel trivial-download usocket daemon unix-opts

all:

cl-skkserv.zip:
	# Bundle
	ros -e "(ql:quickload '($(DEPS)) :silent t)" -e "(ql:bundle-systems '($(DEPS)) :to #p\"./cl-skkserv\")" -q
	# Local Projects
	cd cl-skkserv/local-projects && curl -L https://github.com/asciian/cl-skkserv/archive/master.tar.gz | gunzip -c - | tar xf -
	# Makefile
	echo "all:" > cl-skkserv/Makefile
	echo "	sbcl --load bundle.lisp --eval '(asdf:make :cl-skkserv)'" >> cl-skkserv/Makefile
	# Readme
	cp README.md cl-skkserv/README.md
	# License
	cp LICENSE.md cl-skkserv/LICENSE.md
	# Zip
	zip cl-skkserv.zip -r cl-skkserv 

.PHONY: test clean format http

test:
	./roswell/skkserv.ros start --no-init --port=2278
	ros run -e '(asdf:test-system :cl-skkserv)' -q
	./roswell/skkserv.ros stop --no-init --port=2278

clean:
	find . -name '*~' | xargs rm -f
	rm -rf cl-skksrv/ cl-skkserv.zip 

format:
	find . -name '*.lisp' | xargs gsed -i -e 's/\t/    /g'
	find . -name '*.lisp' | xargs ros fmt

http:
	clackup <(echo "(lack:builder (:static :path #'identity) #'identity)")

