PWD := $(shell pwd)

test:
	luvit $(PWD)/test.lua

.PHONY: test
