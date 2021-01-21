#! /bin/bash
set -euf -o pipefail

base_programs=("https://github.com/vim/vim.git" "https://github.com/tmux/tmux.git")

##########################################
# Installs a package from source via Make
# ARGUMENTS:
#   git url to package
##########################################
function git_make_install() {
	progname=$(basename "$1" .git)
	dir="$repodir/$progname"
	git clone --depth 1 "$1" "$dir"
	cd "$dir" || exit
	if [[ -e "${dir}/autogen.sh" ]]; then
		bash ./autogen.sh || exit 0
	fi
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
}

function install_base() {
	print_step "installing ${#base_programs[@]} programs"
	for program in "${base_programs[@]}"; do
		git_make_install "${program}"
	done
}
