function +vi-git-status() {
  # check for untracked files or updated submodules since vcs_info does not
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    hook_com[unstaged]='%F{yellow}~%f'
  fi
}

function prompt_minimal_precmd {
  vcs_info
}

function prompt_minimal_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)
  # load required functions
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info
  # add hook for calling vcs_info before each command
  add-zsh-hook precmd prompt_minimal_precmd
  # set vcs_info parameters
  zstyle ':vcs_info:*' enable bzr git hg svn
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr '|%F{green}%b%f'
  zstyle ':vcs_info:*' unstagedstr '%F{yellow}~%f'
  zstyle ':vcs_info:*' formats '[%b|%u]'
  zstyle ':vcs_info:*' actionformats "[%b%c%u|%F{cyan}%a%f]"
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b|%F{cyan}%r%f'
  zstyle ':vcs_info:git*+set-message:*' hooks git-status
  # define prompts
  PROMPT='%B%F{240}%1~%f%b ${vcs_info_msg_0_} ᐳ '
  RPROMPT=''

}

typeset -g PROMPT4='%B[%b%F{yellow}%N%f | %F{blue}%I%f%B]%b ᐳ'
prompt_minimal_setup "$@"
