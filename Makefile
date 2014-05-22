EMACS ?= emacs
CASK ?= cask

all: test

test: clean-elc
	${MAKE} test-suite
	${MAKE} compile
	${MAKE} test-suite
	${MAKE} clean-elc

test-suite: unit
	acceptance

unit:
	${CASK} exec ert-runner --no-win

acceptance:
	${CASK} exec ecukes --reporter spec

compile:
	${CASK} exec ${EMACS} -Q -batch -f batch-byte-compile helm-ghc-errors.el

clean-elc:
	rm -f helm-ghc-errors.elc

.PHONY:	all test unit
