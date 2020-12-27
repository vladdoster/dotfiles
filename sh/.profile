export XDG_CONFIG_HOME="$HOME/.config"
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

case "$OSTYPE" in
  darwin*)  
    alias readlink="greadlink"
    ;;
  linux*)
    if [[ $(uname --kernel-release) =~ "arch" ]]; then
        # source arch related scripts
        export PATH="$HOME/.config/arch/statusbar:$PATH"
        echo "btw, I use arch"
    fi
    ;;
  *) 
    echo "unknown: $OSTYPE" ;;
esac

# # if running bash
# if [ -n "$BASH_VERSION" ]; then
#   # include .bashrc if it exists
#   if [ -f "$HOME/.bashrc" ]; then
#     source "$HOME/.bashrc"
#   fi
# fi

# # Ensure local/bin is in path.
# if [ -d "/usr/local/bin" ] ; then
#   export PATH="/usr/local/bin:$PATH"
# fi

# # Misc user bins
# if [ -d "$HOME/bin" ] ; then
#   export PATH="$HOME/bin:$PATH"
# fi

# # Version-controlled scripts
# if [ -d "$HOME/scripts" ] ; then
#   export PATH="$HOME/scripts:$PATH"
# fi

# # Go
# if [ -d "$HOME/go" ]; then
#   export GOPATH="$HOME/go"
#   export PATH="$HOME/go/bin:$PATH"
# fi

# # Rust
# if [ -d "$HOME/.cargo" ] ; then
#   export PATH="$HOME/.cargo/bin:$PATH"
# fi

# # Scripts
# export SCRIPT_PATH="$HOME/scripts"

# # Locale
export LC_ALL="en_US.UTF-8"

# # EDITOR
# export EDITOR='nvim'

# # LESS colouring
# export LESS_TERMCAP_mb=$(printf "\033[01;31m")
# export LESS_TERMCAP_md=$(printf "\033[01;31m")
# export LESS_TERMCAP_me=$(printf "\033[0m")
# export LESS_TERMCAP_se=$(printf "\033[0m")
# export LESS_TERMCAP_so=$(printf "\033[01;44;33m")
# export LESS_TERMCAP_ue=$(printf "\033[0m")
# export LESS_TERMCAP_us=$(printf "\033[01;32m")
