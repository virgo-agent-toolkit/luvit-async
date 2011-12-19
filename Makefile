.PHONY: test

test:
	@LUA_PATH="modules/?/init.lua;tests/?.lua;?;?.lua" luvit tests/async.lua
