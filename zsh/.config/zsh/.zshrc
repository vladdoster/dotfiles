zsh_load_info(){ print -P -- '['%x %I %y']'; }
zsh_load_info

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";

: ${HISTFILE:=${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh_history}
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=2000000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=1000000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt auto_cd auto_pushd extended_glob glob_dots interactive_comments prompt_subst

(){
  local -A dirs=( bin "${HOME}/.local/bin" share "${HOME}/.local/share" config "${HOME}/.config" code "${HOME}/code" zsh "${ZDOTDIR:-$HOME/.config/zsh}" )
  for k v in ${(kv)dirs}; do
    builtin hash -d "${k}"="${v}"
  done
}

fpath=(
  ${ZDOTDIR}/{'comple','func'}tions(N-/)
  $fpath
)
# autoload +X -U bashcompinit; print 'loading bashcompinit'; bashcompinit

for func in ${ZDOTDIR}/functions/*(N-.:t); builtin autoload -Uz -- $func

if (( ! $#NO_RC )); then
  for f in ${ZDOTDIR}/rc.d/<->-*zsh(N); do
    source "$f"
  done
fi

typeset -gxU path=($path) fpath=($fpath)

# vim: set expandtab filetype=zsh shiftwidth=2 softtabstop=2 tabstop=2:
