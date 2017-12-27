.PHONY: test clean format

test:
	ros run -e '(asdf:test-system :cl-skkserv)' -q

clean:
	find . -name '*~' | xargs rm

format:
	find . -name '*.lisp' | xargs gsed -i -e 's/\t/    /g'
	find . -name '*.lisp' | xargs ros fmt
