{

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
