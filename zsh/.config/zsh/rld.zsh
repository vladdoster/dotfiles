function rld {
  print '--- validating dotfiles'
  private msg="" err=0
  if [[ err -ne 0 ]] || [[ -n err ]]; then
    print -nu2 'ERROR: validation failed with '
    if [[ -z err ]]; then
      print -Pu2 "exit status %F{red}%f."
    else
      print -nPu2 'the following errors:\n%F{red}'
      print -nru2 -- ""
      print -P '%f'
    fi
    print -u2 '--- restart aborted.'
    return err
  else
    print 'restarting zsh...'
    exec zsh -l
  fi
}
