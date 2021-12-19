#!/bin/bash
set -euo pipefail

export CPU_BRAND_STRING="$(sysctl -a | /usr/bin/awk '/machdep.cpu.brand_string/{print $2}')"

linuxify_check_os() {
    if ! [[ $OSTYPE =~ darwin* ]]; then
        echo "This is meant to be run on macOS only"
        exit
    fi
}

linuxify_check_brew() {
    if ! command -v brew > /dev/null; then
        echo "Homebrew not installed!"
        echo "In order to use this script please install homebrew from https://brew.sh"
        exit
    fi
}

linuxify_set_prefix() {
    export BREW_PREFIX="$(brew --prefix)"
}

linuxify_check_dirs() {
    result=0
    for dir in "$BREW_PREFIX"/bin "$BREW_PREFIX"/sbin; do
        if [[ ! -d $dir || ! -w $dir ]]; then
            echo "$dir must exist and be writeable"
            result=1
        fi
    done

    return "$result"
}

linuxify_formulas=(
    # GNU programs non-existing in macOS
    "watch"
    "wget"
    "wdiff"
    # "gdb" intel only
    "autoconf"

    # GNU programs whose BSD counterpart is installed in macOS
    "coreutils"
    "binutils"
    "diffutils"
    "ed"
    "findutils"
    "gawk"
    "gnu-indent"
    "gnu-sed"
    "gnu-tar"
    "gnu-which"
    "grep"
    "gzip"
    "screen"

    # GNU programs existing in macOS which are outdated
    "bash"
    "emacs"
    "gpatch"
    "less"
    "m4"
    "make"
    "nano"
    "bison"

    # BSD programs existing in macOS which are outdated
    "flex"

    # Other common/preferred programs in GNU/Linux distributions
    "libressl"
    "file-formula"
    "git"
    "openssh"
    "perl"
    "python"
    "rsync"
    "unzip"
    "vim"
)

linuxify_install_gdb() {
    if ! brew ls --versions gdb > /dev/null; then
        echo "Installing gdb"
        brew install gdb
    fi
    # gdb requires special privileges to access Mach ports.
    # One can either codesign the binary as per https://sourceware.org/gdb/wiki/BuildingOnDarwin
    # Or, on 10.12 Sierra or later with SIP, declare `set startup-with-shell off` in `~/.gdbinit`:
    grep -qF 'set startup-with-shell off' ~/.gdbinit || echo 'set startup-with-shell off' | tee -a ~/.gdbinit > /dev/null
}

linuxify_install() {
    linuxify_check_os
    linuxify_check_brew
    linuxify_set_prefix
    linuxify_check_dirs

    # Install all formulas
    for ((i = 0; i < ${#linuxify_formulas[@]}; i++)); do
        if brew ls --versions "${linuxify_formulas[i]}"; then
            echo "Found Existing ${linuxify_formulas[i]}"
        else
            echo "Installing ${linuxify_formulas[i]}"
            brew install "${linuxify_formulas[i]}"
        fi
    done

    if [[ $CPU_BRAND_STRING != 'Apple' ]]; then
        linuxify_install_gdb
    fi

    # Offer to change shell to newly installed bash
    read -p "Do you want to change your shell to the latest bash (Y/N)? " -n 1 -r
    if [[ $REPLY =~ [Yy]$ ]]; then
        grep -qF "$BREW_PREFIX/bin/bash" /etc/shells || echo "$BREW_PREFIX/bin/bash" | sudo tee -a /etc/shells > /dev/null
        echo # Blank line so the password entry isn't bunched-up
        chsh -s "$BREW_PREFIX"/bin/bash
    else
        echo "OK, leaving your shell as $SHELL"
    fi

    # Make changes to PATH/MANPATH/INFOPATH/LDFLAGS/CPPFLAGS
    cp .linuxify ~/.linuxify
    echo "Add '. ~/.linuxify' to your ~/.bashrc, ~/.zshrc or your shell's equivalent config file"
}

linuxify_uninstall() {
    linuxify_check_os
    linuxify_check_brew
    linuxify_set_prefix

    # Remove gdb fix
    [ -f ~/.gdbinit ] && sed -i.bak '/set startup-with-shell off/d' ~/.gdbinit && rm ~/.gdbinit.bak

    # Offer to change default shell back to macOS default
    bash_is_local=false
    if [[ $SHELL =~ local ]]; then
        read -p "Do you want to change your shell back to macOS default (macOSVersion >= 10.15.x ? zsh : bash) ? " -n 1 -r
        if [[ $REPLY =~ [Yy]$ ]]; then
            sudo sed -i.bak "|$BREW_PREFIX/bin/bash|d" /etc/shells && sudo rm /etc/shells.bak
            echo
            if [[ $(sw_vers -productVersion | awk -F. '{print $2}') -gt 14 ]]; then
                chsh -s /bin/zsh
            else
                chsh -s /bin/bash
            fi
        else
            echo "OK, leaving your shell as $SHELL"
            if [[ $SHELL == $BREW_PREFIX/bin/bash ]]; then
                bash_is_local=true
            fi
        fi
    fi

    # Uninstall all formulas in reverse order
    for ((i = ${#linuxify_formulas[@]} - 1; i >= 0; i--)); do
        if [[ ${linuxify_formulas[i]} != bash ]]; then
            brew uninstall -f "$(echo "${linuxify_formulas[i]}" | cut -d ' ' -f1)"
        fi
    done

    # Only remove bash if the user didn't elect to keep it as their shell
    if [[ $bash_is_local != true ]]; then
        brew uninstall bash
    fi

    # Remove changes to PATH/MANPATH/INFOPATH/LDFLAGS/CPPFLAGS
    rm -f ~/.linuxify
    echo "Remove '. ~/.linuxify' from your ~/.bashrc, ~/.zshrc or your shell's equivalent config file"
}

linuxify_info() {
    linuxify_check_os
    linuxify_check_brew

    for ((i = 0; i < ${#linuxify_formulas[@]}; i++)); do
        brew info "$(echo "${linuxify_formulas[i]}" | cut -d ' ' -f1)"
        printf "\n\n===============================================================================================================================\n\n"
    done
}

linuxify_help() {
    echo "usage: linuxify [-h] [command]"
    echo ""
    echo "valid commands:"
    echo "  install    install GNU/Linux utilities"
    echo "  uninstall  uninstall GNU/Linux utilities"
    echo "  info       show info on GNU/Linux utilities"
    echo ""
    echo "optional arguments:"
    echo "  -h, --help  show this help message and exit"
}

linuxify_main() {
    if [ $# -eq 1 ]; then
        case $1 in
            "install") linuxify_install ;;
            "uninstall") linuxify_uninstall ;;
            "info") linuxify_info ;;
            "-h") linuxify_help ;;
            "--help") linuxify_help ;;
        esac
    else
        linuxify_help
        exit
    fi
}

linuxify_main "$@"
