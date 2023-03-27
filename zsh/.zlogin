{

  # Try in order: C.UTF-8, en_US.UTF-8, the first UTF-8 locale in lexicographical order.
  (( $+commands[locale] )) || return
  local loc=(${(@M)$(locale -a):#*.(utf|UTF)(-|)8})
  (( $#loc )) || return
  export LC_ALL=${loc[(r)(#i)C.UTF(-|)8]:-${loc[(r)(#i)en_US.UTF(-|)8]:-$loc[1]}}

  emulate -L zsh
  setopt nullglob typesetsilent nowarncreateglobal globsubst

  local -aU m
  local md
  for md ($module_path); do
    m=($m $md/**/*(*e:'REPLY=${REPLY#$md/}'::r))
    zmodload -i $m
  done

  # Compile the completion dump to increase startup speed.
  zcompdump="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "$zcompdump"
      command rmdir  "${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi

  autoload -U zrecompile
  for ((i=1; i <= $#fpath; ++i)); do
    dir=$fpath[i]
    zwc=${dir:t}.zwc
    if [[ $dir == (.|..) || $dir == (.|..)/* ]]; then
      continue
    fi
    files=($dir/*(N-.))
    if [[ -w $dir:h && -n $files ]]; then
      files=(${${(M)files%/*/*}#/})
      if ( cd $dir:h &&
        zrecompile -p -U -z $zwc $files ); then
        fpath[i]=$fpath[i].zwc
      fi
    fi
  done
} &!

# vim: set fenc=utf8 ffs=unix ft=zsh list et sts=2 sw=2 ts=2 tw=100:
