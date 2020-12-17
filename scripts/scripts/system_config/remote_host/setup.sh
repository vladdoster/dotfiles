#! /bin/bash
set -euf -o pipefail

base_programs=("https://github.com/vim/vim.git" \
              "https://github.com/tmux/tmux.git"

##########################################
# Installs a package from source via Make
# ARGUMENTS:
#   git url to package
##########################################
git_make_install() {
	progname="$(basename "$1" .git)"
	dir="$repodir/$progname"
	sudo -u "$name" git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || { cd "$dir" || return ; sudo -u "$name" git pull --force origin master;}
	cd "$dir" || exit
  { [[ -e FILE ]]	&& ./autogen.sh ;} || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return ;}

function install_base(){
  print_step "installing ${#base_programs[@]} programs"
  for program in "${base_programs[@]}"; do
    print_step_info "$program"
    git_make_install $program >/dev/null 2>&1
  done
