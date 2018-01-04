SHELL=/bin/bash
DEPS=alexandria cl-ppcre esrap 1am portable-threads jp-numeral drakma flexi-streams yason papyrus named-readtables babel trivial-download usocket daemon

all:

.PHONY: test clean format http build

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

build:
	rm -rf build && mkdir build
	ros -e "(ql:quickload '($(DEPS)) :silent t)" -e "(ql:bundle-systems '($(DEPS)) :to #p\"./build\")" -q
	cd build/local-projects && curl -L https://github.com/asciian/cl-skkserv/archive/master.tar.gz | gunzip -c - | tar xf -
	cd build/local-projects && curl -L https://github.com/asciian/trivial-argv/archive/master.tar.gz | gunzip -c - | tar xf -
	tail -n+2 roswell/skkserv.ros > build/skkserv.lisp
	echo "(sb-ext:save-lisp-and-die \"skkserv\" :toplevel (lambda () (apply #'main sb-ext:*posix-argv*)) :executable t)" >> build/skkserv.lisp
	echo "all:" > build/Makefile
	echo "	sbcl --load bundle.lisp --script skkserv.lisp" >> build/Makefile
