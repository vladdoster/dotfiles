# General
alias pcp="rsync --progress -ah"
alias tailf="less +F -R"
alias ls="exa -lga --group-directories-first"
alias ll="ls"
alias sha256="shasum -a 256"
alias sha1="openssl sha1"
alias fetch="curl -LO#"
alias sz="source $HOME/.zshrc"
alias sshkey="clip $HOME/.ssh/id_rsa.pub && echo 'Copied SSH key to clipboard.'"
alias ducks="du -cksh * | sort -hr"
alias myip='curl ifconfig.co'
alias genpass="openssl rand -base64 24"
alias n="nnn"
alias lg="lazygit"
alias cat="bat"
alias ca="cat"
alias ssh-fingerprint="ssh-keygen -E md5 -lf"
alias serve="python -m SimpleHTTPServer"
alias ssh="TERM=xterm ssh" # kitty has issues

# Ruby/Rails
alias c="clear"
alias be="bundle exec"
alias rake="bundle exec rake"
alias rspec="bundle exec rspec"
alias cap="bundle exec cap"
alias rails="bundle exec rails"
alias html2haml="html2haml --ruby19-attributes --erb"
alias rdbc="rails db:create db:schema:load"
alias rtdbc="RAILS_ENV=test rails db:create"
alias csdp="SKIP_DATA_SYNC_CONFIRM=true cap staging db:pull"
alias cpdp="SKIP_DATA_SYNC_CONFIRM=true cap production db:pull"

alias tm="tmux"
alias tmn="tmux new -s"
alias tma="tmux attach-session -t"
alias tmks="tmux kill-server"

alias vi="nvim"
alias vim="nvim"
alias v="nvim"
alias v.="nvim ."
alias scratch="vim $(mktemp -t scratch.XXX.md)"

# 'latest' will refer to the last modified file.
#
# e.g. `open latest`
#        `rm latest`
alias -g latest='*(om[1])'

# Most git aliases are in ~/.gitconfig.
alias g='git'
alias gcd='cd $(git rev-parse --show-toplevel)'

alias dex="docker exec -it"
alias rg="rg --ignore-file $HOME/.ignore"
