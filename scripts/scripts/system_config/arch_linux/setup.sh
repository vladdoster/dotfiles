#! /bin/bash
set -euf -o pipefail

# ====== Variables ====== #
while getopts ":a:r:b:p:h" o; do case "${o}" in
	h) printf 'Optional arguments for custom use:\n  -r: Dotfiles repository (local file or url)\n  -p: Dependencies and programs csv (local file or url)\n  -a: AUR helper (must have pacman-like syntax)\n  -h: Show this message\n' && exit ;;
	r) dotfiles_repo=${OPTARG} && git ls-remote "$dotfiles_repo" || exit ;;
	b) repo_branch=${OPTARG} ;;
	p) user_programs_file=${OPTARG} ;;
	a) aur_helper=${OPTARG} ;;
	*) printf 'Invalid option: -%s\n' "$OPTARG" && exit ;;
	esac done

[ -z "$dotfiles_repo" ] && dotfiles_repo="https://github.com/vladdoster/linux-dotfiles.git"
[ -z "$user_programs_file" ] && user_programs_file="https://raw.githubusercontent.com/vladdoster/dotfiles-installer/master/old-programs.csv"
[ -z "$aur_helper" ] && aur_helper="yay"
[ -z "$repo_branch" ] && repo_branch="master"

BACKTITLE="System bootstrap"
TITLE="Configuration files installer"
USER_PROGRAMS_PARSE_PATTERN='"^[PGA]*,"'
# ======================= #
#       Dialog boxes      #
# ======================= #
display_info_box() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--infobox "$1" \
		0 0
}

display_input_box() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--no-cancel \
		--inputbox "$1" \
		0 0 \
		3>&1 1>&2 2>&3 3>&1
}

display_password_input() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--no-cancel \
		--passwordbox "$1" \
		0 0 \
		3>&1 1>&2 2>&3 3>&1
}
# ======================= #
#   Installer functions   #
# ======================= #
add_dotfiles() {
	display_info_box "Downloading and installing config files at /home/$name..."
	user_home_dir="/home/$name"
	dir=$(mktemp -d)
	[ ! -d "$user_home_dir" ] && mkdir -p "$user_home_dir"
	chown -R "$name":wheel "$dir" "$user_home_dir"
	sudo -u "$name" git clone --recursive --branch "$repo_branch" --depth 1 "$dotfiles_repo" "$dir"
	sudo -u "$name" cp -rfT "$dir" "$user_home_dir"
	rm -f "$user_home_dir/README.md" "$user_home_dir/LICENSE"
	# make git ignore deleted LICENSE & README.md files
	cd "$user_home_dir" && git update-index --assume-unchanged "$user_home_dir/README.md" "$user_home_dir/LICENSE"
}

arch_pkg_install() {
	display_info_box "Installing \`$1\`\n($n of $total)"
	install_pkg "$1"
}

aur_pkg_install() {
	display_info_box "Installing \`$1\` from the AUR\n($n of $total)"
	echo "$aurinstalled" | grep "^$1$" >/dev/null 2>&1 && return
	sudo -u "$name" "$aur_helper" -S --noconfirm "$1" >/dev/null 2>&1
}

create_fake_root_install_env() {
	display_info_box "Creating fake root environment..."
	set_permissions "%wheel ALL=(ALL) NOPASSWD: ALL"
}

create_user_dirs() {
	mkdir -p "/home/$name/github"
	mkdir -p "/home/$name/downloads"
}

enable_docker() {
	# https://docs.docker.com/install/linux/linux-postinstall/
	systemctl enable docker.service
	systemctl start docker.service
	usermod -aG docker "$name"
}

enable_multicore_make_compilations() {
	display_info_box "Enable all cores in Make compilations"
	sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf
}

error() {
	clear
	printf 'ERROR:\n%s\n' "$1"
	exit
}

get_user_credentials() {
	# Prompts user for new username and password.
	name=$(display_input_box "First, please enter a name for the user account.") || exit
	while ! echo "$name" | grep "^[a-z_][a-z0-9_-]*$" >/dev/null 2>&1; do
		name=$(display_input_box "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _.")
	done
	user_passwd=$(display_password_input "Enter a password for that user.")
	confirm_user_passwd=$(display_password_input "Retype password.")
	while ! [ "$user_passwd" = "$confirm_user_passwd" ]; do
		unset confirm_user_passwd
		user_passwd=$(display_password_input "Passwords do not match.\n\nEnter password again")
		confirm_user_passwd=$(display_password_input "Retype password.")
	done
}

git_pkg_install() {
	progname="$(basename "$1")"
	dir="$repodir/$progname"
	display_info_box "Installing \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2"
	sudo -u "$name" git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || {
		cd "$dir" || return
		sudo -u "$name" git pull --force origin master
	}
	cd "$dir" || exit
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return
}

install_dependencies() {
	display_info_box "Installing dependencies for installation"
	install_pkg curl
	install_pkg base-devel
	install_pkg git
	install_pkg ntp
}

install_nvim_plugins() {
	display_info_box "Installing Neovim plugins"
	nvim +PlugInstall +qall
}

install_pkg() { pacman --noconfirm --needed -S "$1" >/dev/null 2>&1; }

install_user_programs() {
	([ -f "$user_programs_file" ] && cp "$user_programs_file" /tmp/user_programs.csv) || curl -Ls "$user_programs_file" | sed '/^#/d' | eval grep "$USER_PROGRAMS_PARSE_PATTERN" >/tmp/user_programs.csv
	total=$(wc -l </tmp/user_programs.csv)
	aurinstalled=$(pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n + 1))
		echo "$comment" | grep "^\".*\"$" >/dev/null 2>&1 && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
		"A") aur_pkg_install "$program" "$comment" ;;
		"G") git_pkg_install "$program" "$comment" ;;
		"P") pip_pkg_install "$program" "$comment" ;;
		*) arch_pkg_install "$program" "$comment" ;;
		esac
	done </tmp/user_programs.csv
}

manual_install() {
	[ -f "/usr/bin/$1" ] || (
		dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
		cd /tmp || exit
		rm -rf /tmp/"$1"*
		curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
			sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
			cd "$1" &&
			sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
		cd /tmp || return
	)
}

pip_pkg_install() {
	display_info_box "Installing the Python package \`$1\` ($n of $total). $1 $2"
	command -v pip || install_pkg python-pip >/dev/null 2>&1
	yes | pip install "$1"
}

prettify_pacman() {
	display_info_box "Make pacman more appealing on the eyes"
	grep "^Color" /etc/pacman.conf >/dev/null || sed -i "s/^#Color$/Color/" /etc/pacman.conf
	grep "ILoveCandy" /etc/pacman.conf >/dev/null || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
}

set_postinstall_settings() {
	# Zsh is default shell
	chsh -s /bin/zsh "$name" >/dev/null 2>&1
	sudo -u "$name" mkdir -p "/home/$name/.cache/zsh/"
	#sed -i "s/^$name:\(.*\):\/bin\/.*/$name:\1:\/bin\/zsh/" /etc/passwd

	# Allows user to execute `shutdown`, `reboot`, updating, etc. without password
	set_permissions "%wheel ALL=(ALL) ALL #SYSBOOTSTRAP
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/pacman -Syyuw --noconfirm"

	enable_docker || error "Couldn't enable docker."
	install_nvim_plugins || error "Couldn't install nvim plugins"
	start_pulse_audio_daemon || error "Couldn't start Pulse audio daemon"
	system_beep_off || error "Couldn't turn off system beep, erghh!"
	create_user_dirs || error "Couldn't make github  or downloads dir."
}

set_preinstall_settings() {
	[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers
	synchronize_clocks_with_ntp || error "Couldnt sync clocks with NTP"
	create_fake_root_install_env || error "Couldnt create fake root env for install"
	prettify_pacman || error "Could not prettify pacman"
	enable_multicore_make_compilations || error "Couldnt enable multicore Make compilations"
}

set_permissions() {
	display_info_box "Set special 'sudoers' settings"
	sed -i "/#SYSBOOTSTRAP/d" /etc/sudoers
	echo "$* #SYSBOOTSTRAP" >>/etc/sudoers
}

set_user_credentials() {
	display_info_box "Adding user \"$name\"..."
	useradd -m -g wheel -s /bin/bash "$name" >/dev/null 2>&1 ||
		usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	repodir="/home/$name/.local/src"
	mkdir -p "$repodir"
	chown -R "$name":wheel $(dirname "$repodir")
	echo "$name:$user_passwd" | chpasswd
	unset user_passwd confirm_user_passwd
}

start_pulse_audio_daemon() {
	killall pulseaudio
	sudo -u "$name" pulseaudio --start
}

successful_install_alert() {
	unsuccessfully_installed_programs=$(printf "\n" && echo "$(curl -s "${user_programs_file}" | sed '/^#/d')" | while IFS=, read -r tag program comment; do if [[ $tag == 'G' ]]; then printf "%s\n" "$program"; elif [[ "$(pacman -Qi "$program" >/dev/null)" ]]; then printf "%s\n" "$program"; fi; done)
	dialog \
		--backtitle "$BACKTITLE" \
		--title "Configuration files installed" \
		--msgbox "If no hidden errors, dotfile-installer.sh completed successfully.\nNumber of programs installed -> $total. \nPrograms that might not have gotten installed\n:$unsuccessfully_installed_programs" \
		0 0
}
synchronize_clocks_with_ntp() {
	display_info_box "Synchronizing system time to ensure successful and secure installation of software..."
	ntpdate 0.us.pool.ntp.org >/dev/null 2>&1
}
system_beep_off() {
	display_info_box "Getting rid of that retarded error beep sound..."
	rmmod pcspkr ||
		display_info_box "pcspkr module not loaded, skipping..."
	echo "blacklist pcspkr" >/etc/modprobe.d/nobeep.conf
}
user_confirm_install() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--yes-label "Let's go!" \
		--no-label "No, nevermind!" \
		--yesno "The rest of the installation will now be totally automated, so sit back and relax.\\n\\nNow just press <Let's go!> and the system will begin installation!" \
		0 0 || {
		clear
		exit
	}
}
refresh_arch_keyring() {
	display_info_box "Refreshing Arch keyring"
	pacman --noconfirm -Sy archlinux-keyring >/dev/null 2>&1
}
run_reflector() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--defaultno \
		--yesno "Install and run reflector? It might speed up package downloads." \
		0 0
	response=$?
	case $response in
	0)
		display_info_box "Installing reflector"
		install_pkg reflector
		display_info_box "Running reflector"
		reflector --verbose --latest 100 --sort rate --save /etc/pacman.d/mirrorlist >/dev/null 2>&1
		;;
	1)
		return
		;;
	esac
}
user_exists_warning() {
	! (id -u "$name" >/dev/null) 2>&1 ||
		dialog \
			--colors \
			--backtitle "$BACKTITLE" \
			--title "$TITLE" \
			--yes-label "CONTINUE" \
			--no-label "No wait..." \
			--yesno "User already exists on this system. Continuing will overwrite conflicting files." \
			0 0
}
welcome_screen() {
	dialog \
		--backtitle "$BACKTITLE" \
		--title "$TITLE" \
		--msgbox "Welcome! This script automatically installs a fully-featured Arch Linux desktop." \
		0 0
}
# ======================= #
#         Install         #
# ======================= #
install_dependencies
welcome_screen || error "User exited welcome_screen()"
get_user_credentials || error "Error in prompt_user_credentials()"
user_exists_warning || error "user_exists_warning() could not continue"
user_confirm_install || error "user_confirm_install() could not continue"
set_user_credentials || error "Error adding user in set_user_credentials()"
refresh_arch_keyring || error "Error automatically refreshing Arch keyring. Consider doing so manually."
run_reflector || error "run_reflector() encountered an error"
set_preinstall_settings || error "set_preinstall_settings() did not finish successfully"
manual_install $aur_helper || error "Failed to install yay via manual_install()"
install_user_programs || error "Error in install_user_programs()"
add_dotfiles || error "Error in add_dotfiles()"
set_postinstall_settings || error "set_postinstall_settings() did not finish successfully"
successful_install_alert || error "Unfortunately, the install failed. Better luck next time."
