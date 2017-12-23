.PHONY: test clean

test:
	ros run -e '(asdf:test-system :lime)' -q

clean:
	find . -name '*~' | xargs rm
