rld() {
  # validate dotfiles & safely restart Zsh
  # args: --
  print 'Validating dotfiles...'
  # These need to be two separate statements or we won't get the right `$?`.
  private msg=
  msg="$(exec zsh -ilc exit 2>&1 > /dev/null)"
  private err=$?
  if [[ err -ne 0 || -n $msg ]]; then
    print -nu2 'Validation failed with '
    if [[ -z $msg ]]; then
      print -Pu2 "exit status %F{red}$err%f."
    else
      print -nPu2 'the following errors:\n%F{red}'
      print -nru2 -- "$msg"
      print -P '%f'
    fi
    print -u2 'Restart aborted.'
    return err
  else
    print 'Restarting Zsh...'
    exec zsh -l
  fi
}

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
