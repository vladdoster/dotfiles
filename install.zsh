#!/usr/bin/env zsh
# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:
#
# install.zsh - bootstrap vladdoster/dotfiles
#
# Remote, Homebrew-style (arguments after the command substitution reach the script, with the
# first one becoming $0):
#   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/vladdoster/dotfiles/master/install.zsh)"
#   /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/vladdoster/dotfiles/master/install.zsh)" install.zsh --only stow --dry-run
# Local:
#   zsh install.zsh [flags]
#
# The script owns only preflight and the initial clone; every other section delegates to the
# repository's Makefile, so behavior stays identical to running the targets by hand. --dry-run
# prints the make invocations themselves; for recipe-level expansion use `make -n -C <prefix>
# <target>` against an existing clone. --branch selects what gets cloned, not which script
# runs -- the raw URL always serves master's copy, the same property Homebrew's installer has.

# The repo's log::info gates on interactivity ($- == *i*) and a curl-piped shell is
# non-interactive, so these self-contained equivalents gate colors on a TTY instead. Same
# names, so call sites read identically to the autoloaded functions.
log::info()  { [[ -t 1 ]] && builtin print -P -- "%F{green}==>%f %F{white}${*}%f" || builtin print -r -- "==> ${*}" }
log::error() { [[ -t 2 ]] && builtin print -P -u2 -- "%F{red}Error:%f ${*}" || builtin print -r -u2 -- "Error: ${*}" }
log::warn()  { [[ -t 2 ]] && builtin print -P -u2 -- "%F{yellow}Warning:%f ${*}" || builtin print -r -u2 -- "Warning: ${*}" }

# Locate brew the way the stowed .zprofile does and load its shellenv, so delegated make
# targets inherit a PATH that can see it. Returns 1 when no brew exists yet.
brew::env() {
  local -a brew_bin=(
    /{opt,usr/local}/[Hh]omebrew/bin/brew(N-.)
    {/home/linuxbrew,${HOME}}/.linuxbrew/bin/brew(N-.)
  )
  (($#brew_bin)) || return 1
  eval "$(${brew_bin[1]} shellenv zsh)"
}

# delegate <label> <make-target>... -- run targets from the clone's Makefile. Exact target
# names matter: the Makefile has a catch-all `%:` rule, so a typo'd target silently succeeds.
# The Makefile check is skipped under --dry-run so a fresh-machine preview can print the full
# plan before any clone exists.
delegate() {
  if ((! $#flag_dry)) && [[ ! -f ${prefix}/Makefile ]]; then
    log::error "${1}: no Makefile at ${prefix}; run the clone section first"
    ((failures++))
    return 1
  fi
  if ! $run make -C ${prefix} ${@[2,-1]}; then
    log::error "${1}: make ${(j: :)${@[2,-1]}} failed"
    ((failures++))
    return 1
  fi
  return 0
}

main() {
  builtin emulate -L zsh -o EXTENDED_GLOB

  autoload -Uz is-at-least
  is-at-least 5.8 || { log::error "zsh >= 5.8 required (zparseopts -F)"; return 1 }

  local -a flag_debug flag_help flag_dry opt_branch opt_only opt_prefix
  local -a sections=(clone brew bundle stow shell extras)
  local -a default_sections=(clone brew bundle stow)
  local -a usage=(
    "install.zsh [-b|--branch <name>] [-d|--debug] [-h|--help] [-n|--dry-run]"
    "            [-o|--only <section>[,<section>...]] [-p|--prefix <dir>]"
    ""
    "Bootstrap vladdoster/dotfiles: clone the repository, then drive its Makefile."
    ""
    "Options:"
    "  -b, --branch       git branch to clone (default: master)"
    "  -d, --debug        turn on execution tracing"
    "  -h, --help         show list of command-line options"
    "  -n, --dry-run      print every command instead of running it"
    "  -o, --only         run only the named sections (repeatable, or comma-separated)"
    "  -p, --prefix       clone/install location (default: ~/.config/dotfiles)"
    ""
    "Sections (default: ${(j:, :)default_sections}):"
    "  clone    git clone the dotfiles repository"
    "  brew     install Homebrew (make brew-install)"
    "  bundle   sync Brewfile packages -- removes unlisted formulae (make brew-bundle)"
    "  stow     symlink dotfile packages into \$HOME (make install)"
    "  shell    set the login shell to zsh (make chsh)"
    "  extras   clone neovim + hammerspoon configurations (make neovim hammerspoon)"
  )

  zmodload zsh/zutil || return 1
  builtin zparseopts -D -E -F -K -- \
    {b,-branch}:=opt_branch \
    {d,-debug}=flag_debug \
    {h,-help}=flag_help \
    {n,-dry-run}=flag_dry \
    {o,-only}+:=opt_only \
    {p,-prefix}:=opt_prefix || return 1

  # -F rejects unknown *options* but leaves operands in $@, so without this `install.zsh
  # stow` -- the obvious slip for `-o stow` -- would fall through and run the full bootstrap.
  if (($#)); then
    log::error "unexpected argument: ${1}"
    builtin print -u2 -- "did you mean: install.zsh --only ${1}"
    return 1
  fi

  # "${(@)usage}" rather than $usage: an unquoted array drops its empty elements, which
  # would collapse the blank lines separating the usage sections.
  (($#flag_help)) && {
    builtin print -l -- "${(@)usage}"
    return 0
  }
  (($#flag_debug)) && setopt xtrace

  local -a run=()
  (($#flag_dry)) && run=(builtin print -r --)
  local -i failures=0

  local prefix=${XDG_CONFIG_HOME:-${HOME}/.config}/dotfiles
  local branch=master
  # zparseopts keeps the separator on the GNU --prefix=dir form, so strip a leading =.
  (($#opt_prefix)) && prefix=${opt_prefix[-1]#=}
  (($#opt_branch)) && branch=${opt_branch[-1]#=}

  # --only may be given repeatedly and/or comma-separated; zparseopts leaves flag/value pairs.
  local -a want=()
  local -A do_section
  local s i
  for ((i = 2; i <= $#opt_only; i += 2)); do
    want+=(${(s:,:)${opt_only[i]#=}})
  done
  # Gated on $#opt_only, not $#want: `--only ''` and `--only ,` split to nothing and must
  # fail closed rather than silently meaning "the default sections".
  if (($#opt_only)) && ((! $#want)); then
    log::error "--only given with no sections"
    builtin print -u2 -- "valid sections: ${(j:, :)sections}"
    return 1
  fi
  if (($#want)); then
    for s in $want; do
      ((${sections[(Ie)$s]})) || {
        log::error "unknown section: ${s}"
        builtin print -u2 -- "valid sections: ${(j:, :)sections}"
        return 1
      }
      do_section[$s]=1
    done
  else
    for s in $default_sections; do do_section[$s]=1; done
  fi

  ##############################################################################
  # Preflight                                                                  #
  ##############################################################################
  # The stowed zsh env exports GIT_CONFIG pointing at the repo's tracked config; inherited
  # here it breaks the Homebrew installer and makes any `git config` write edit tracked
  # files. make and git inherit the cleaned environment.
  unset GIT_CONFIG GIT_DIR GIT_WORK_TREE

  [[ -n ${NONINTERACTIVE-} ]] && export NONINTERACTIVE
  if [[ -z ${NONINTERACTIVE-} ]] && { [[ -n ${CI-} ]] || [[ ! -t 0 ]] }; then
    export NONINTERACTIVE=1
    log::info "stdin is not a TTY or CI is set; running non-interactively"
  fi

  # make and git both come from the Command Line Tools on macOS -- /usr/bin/git is a shim
  # that pops a GUI dialog until they exist, so probe xcode-select -p, not $+commands[git],
  # and settle this before anything tries to clone or delegate.
  if [[ ${OSTYPE} == darwin* ]] && ! command xcode-select -p &> /dev/null; then
    if [[ -n ${NONINTERACTIVE-} ]]; then
      log::error "Xcode Command Line Tools missing; run: xcode-select --install"
      return 1
    fi
    log::info "installing the Xcode Command Line Tools (a dialog will open)"
    $run xcode-select --install
    if ((! $#flag_dry)); then
      local -i waited=0
      until command xcode-select -p &> /dev/null; do
        command sleep 5
        ((waited += 5))
        ((waited % 60)) || log::info "waiting for the Command Line Tools installer to finish"
        if ((waited >= 1800)); then
          log::error "gave up waiting for the Command Line Tools after 30 minutes"
          return 1
        fi
      done
    fi
  fi

  if [[ ${OSTYPE} != darwin* ]]; then
    local -a missing=()
    ((${+commands[git]})) || missing+=(git)
    ((${+commands[make]})) || missing+=(make)
    if (($#missing)); then
      log::error "missing required tools: ${(j:, :)missing}"
      builtin print -u2 -- "install them first, e.g.: apt install ${(j: :)missing}  /  pacman -S ${(j: :)missing}"
      return 1
    fi
  fi

  if ((${+do_section[stow]} && ! ${+do_section[bundle]} && ! $+commands[stow])); then
    log::warn "stow not found and the bundle section is not selected; the stow section will fail (install stow, or run: make -C ${prefix} build-stow)"
  fi

  ##############################################################################
  # clone                                                                      #
  ##############################################################################
  # The only section the script performs itself -- the Makefile does not exist yet. The
  # existence check runs even under --dry-run: it is read-only and the honest answer.
  if ((${+do_section[clone]})); then
    if [[ -e ${prefix} || -h ${prefix} ]]; then
      log::error "${prefix} already exists"
      builtin print -u2 -l -- \
        "update it:        git -C ${prefix} pull --ff-only" \
        "or remove it:     rm -rf ${prefix}" \
        "or skip cloning:  install.zsh --only brew,bundle,stow"
      return 1
    fi
    log::info "cloning the ${branch} branch into ${prefix}"
    $run mkdir -p -- ${prefix:h}
    if ! $run git clone --branch ${branch} https://github.com/vladdoster/dotfiles.git ${prefix}; then
      log::error "git clone failed"
      return 1
    fi
  fi

  ##############################################################################
  # brew                                                                       #
  ##############################################################################
  if ((${+do_section[brew]})); then
    brew::env || :
    if (($+commands[brew])); then
      log::info "homebrew already installed: ${commands[brew]}"
    elif delegate brew brew-install && ((! $#flag_dry)); then
      brew::env || log::warn "homebrew installed but brew not found on PATH"
    fi
  fi

  ##############################################################################
  # bundle                                                                     #
  ##############################################################################
  if ((${+do_section[bundle]})); then
    brew::env || :
    if ((! $+commands[brew] && ! $#flag_dry)); then
      log::error "bundle: brew not on PATH; run the brew section first"
      ((failures++))
    else
      delegate bundle brew-bundle
    fi
  fi

  ##############################################################################
  # stow                                                                       #
  ##############################################################################
  if ((${+do_section[stow]})); then
    delegate stow install \
      || builtin print -u2 -- "hint: a pre-existing file in ${HOME} conflicts with a package symlink; move it aside and re-run"
  fi

  ##############################################################################
  # shell                                                                      #
  ##############################################################################
  if ((${+do_section[shell]})); then
    if [[ -n ${NONINTERACTIVE-} ]] && ((! $#flag_dry)); then
      log::error "shell: chsh needs an interactive sudo prompt"
      ((failures++))
    else
      delegate shell chsh
    fi
  fi

  ##############################################################################
  # extras                                                                     #
  ##############################################################################
  if ((${+do_section[extras]})); then
    local -a extra_targets=(neovim)
    [[ ${OSTYPE} == darwin* ]] && extra_targets+=(hammerspoon)
    delegate extras ${extra_targets}
  fi

  ##############################################################################
  # Epilogue                                                                   #
  ##############################################################################
  if ((failures)); then
    log::error "${failures} step(s) failed; see the errors above"
    return 1
  fi
  if (($#flag_dry)); then
    log::info "dry run complete"
    return 0
  fi
  log::info "dotfiles installed"
  log::info "next steps:"
  builtin print -l -- \
    "  exec zsh -li             # start a login shell with the new configuration" \
    "  make -C ${prefix} help   # list every available target"
  [[ ${OSTYPE} == darwin* ]] && builtin print -r -- "  bootstrap-macos          # apply macOS system preferences"
  return 0
}

# The whole body lives in functions and this is the only top-level command, so a truncated
# curl download can never execute half a script -- zsh parses everything before running it.
main "$@"
