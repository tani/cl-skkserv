.PHONY: test clean

test:
	ros run -e '(asdf:test-system :lime)' -q

clean:
	find . -name '*~' | xargs rm

format:
	find . -name '*.lisp' | xargs gsed -i -e 's/\t/    /g'
	find . -name '*.lisp' | xargs ros fmt
