#!/usr/bin/env zsh
# zprofile::env-variables() {
#   (( ${+TERM} )) || export TERM="xterm-256color"; COLORTERM="truecolor"
#   (( ${+USER} )) || export USER="${USERNAME}"
#   (( ${+XDG_CACHE_HOME} )) || export XDG_CACHE_HOME="${HOME}/.cache"
#   (( ${+XDG_CONFIG_HOME} )) || export XDG_CONFIG_HOME="${HOME}/.config"
#   (( ${+XDG_DATA_HOME} )) || export XDG_DATA_HOME="${HOME}/.local/share"
#   # configuration directories
#   export \
#     DOTFILES="${XDG_CONFIG_HOME}/dotfiles" GIT_CONFIG="${XDG_CONFIG_HOME}/git/config" \
#     PIP_CONFIG="${XDG_CONFIG_HOME}/pip" PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/init-repl.py" \
#     VIMDOTDIR="${XDG_CONFIG_HOME}/vim" ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
#   # program options
#   export \
#     COMPOSE_DOCKER_CLI_BUILD=1 CORRECT_IGNORE="*zinit[-]*" \
#     DISABLE_MAGIC_FUNCTIONS=1 DOCKER_BUILDKIT=1 \
#     HOMEBREW_NO_{ENV_HINTS,INSTALL_CLEANUP}=1 \
#     SHELL_SESSIONS_DISABLE=1
# }
# zprofile::initialize-homebrew() {
#   if [[ -e /opt/homebrew/bin/brew ]]; then
#     BREW_LOCATION="/opt/homebrew"
#   elif [[ -e /usr/local/bin/brew ]]; then
#     BREW_LOCATION="/usr/local"
#   elif [[ -e /home/linuxbrew/.linuxbrew/bin/brew ]]; then
#     BREW_LOCATION="/home/linuxbrew/.linuxbrew"
#   fi
#   eval "$("$BREW_LOCATION"/bin/brew shellenv)"
#   path+=( ${BREW_LOCATION}/(s|)bin path)
# }
# zprofile::locale() {
#   export L{ANG{,UAGE},C_ALL}='en_US.UTF-8'
# }
# # +──────+
# # │ MAIN │
# # +──────+
# zprofile::env-variables
# zprofile::locale
# zprofile::initialize-homebrew

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
