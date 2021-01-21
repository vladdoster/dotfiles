# --- default programs --- #
export EDITOR="nvim"

# --- directory variables --- #
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_USER_LOCAL="${HOME}/.local"
export XDG_DATA_HOME="${XDG_USER_LOCAL:-$HOME/.local}/share"
export XDG_USER_BINARIES="${XDG_USER_LOCAL:-$HOME/.local}/bin"

# ---  $HOME clean-up --- #

export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export INPUTRC="${XDG_CONFIG_HOME}/inputrc"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/startup"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"                     
export GOPATH="${XDG_DATA_HOME}/go"                            

# --- less --- #
export LESS=-R
export LESSHISTFILE="-"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"

# --- misc. environment variables --- #
export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"
