all: fmt
deps:
	luarocks install --server=https://luarocks.org/dev luaformatter
fmt:
		@find . -name '*.lua' -print -exec \
			lua-format \
			--config .lua_format.yml \
			--in-place \
			-- {} \;
