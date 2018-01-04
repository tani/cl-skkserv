SHELL=/bin/bash
DEPS=alexandria cl-ppcre esrap 1am portable-threads jp-numeral drakma flexi-streams yason papyrus named-readtables babel trivial-download usocket daemon

all:

.PHONY: test clean format http build

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

package:
	rm -rf cl-skkserv
	# Bundle
	ros -e "(ql:quickload '($(DEPS)) :silent t)" -e "(ql:bundle-systems '($(DEPS)) :to #p\"./cl-skkserv\")" -q
	# Local Projects
	cd cl-skkserv/local-projects && curl -L https://github.com/asciian/cl-skkserv/archive/master.tar.gz | gunzip -c - | tar xf -
	cd cl-skkserv/local-projects && curl -L https://github.com/asciian/trivial-argv/archive/master.tar.gz | gunzip -c - | tar xf -
	# Roswell Srcipt
	tail -n+2 roswell/skkserv.ros > cl-skkserv/skkserv.lisp
	echo "(sb-ext:save-lisp-and-die \"skkserv\" :toplevel (lambda () (apply #'main sb-ext:*posix-argv*)) :executable t)" >> cl-skkserv/skkserv.lisp
	# Makefile
	echo "all:" > cl-skkserv/Makefile
	echo "	sbcl --load bundle.lisp --script skkserv.lisp" >> cl-skkserv/Makefile
	# Readme
	cp README.md cl-skkserv/README.md
	# License
	cp LICENSE.md cl-skkserv/LICENSE.md
	# Package
	zip cl-skkserv.zip -r cl-skkserv 
