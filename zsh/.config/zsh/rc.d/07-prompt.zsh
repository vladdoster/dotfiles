setopt prompt_subst

autoload -Uz add-zsh-hook vcs_info
add-zsh-hook precmd vcs_info

# Only check for git repositories
zstyle ':vcs_info:*' enable git

# Check repositories for unstaged and staged changes
zstyle ':vcs_info:*' check-for-changes true

# Define strings for changes (%u = unstaged, %c = staged)
zstyle ':vcs_info:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'

# Format string: (branch * +)
zstyle ':vcs_info:git:*' formats '[%b%u%c] '
zstyle ':vcs_info:git:*' actionformats '[%b|%a%u%c] '

PROMPT='%B%F{cyan}%2~%f%b ${vcs_info_msg_0_}$ '
