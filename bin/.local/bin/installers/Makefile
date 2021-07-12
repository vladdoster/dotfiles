
.PHONY: libevent tmux auto-tools

auto-tools: 
	bash ./m4.sh
	bash ./autoconf.sh
	bash ./automake.sh

libevent: auto-tools
	bash libevent.sh

tmux: libevent
	bash tmux.sh
