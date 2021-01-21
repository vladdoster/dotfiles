#!/usr/bin/env zsh
#
# Installs git completion for zsh
#

# Download the scripts
curl -o ${ZDOTDIR:-$HOME}/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ${ZDOTDIR:-$HOME}/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

# add code to zshrc
cat <<EOT >>${ZDOTDIR:-$HOME}/.zshrc
# Load Git completion
zstyle ':completion:*:*:git:*' script ${ZDOTDIR}/git-completion.bash
fpath=(${ZDOTDIR:-$HOME}/.zshrc $fpath)

autoload -Uz compinit && compinit
EOT

rm ${ZDOTDIR:-$HOME}/.zcompdump
