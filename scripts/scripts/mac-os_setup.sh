#! /bin/bash
set -e pipefail

IFS=$' \t\n' var=$* # make single string from multiple words
PROGRAMS_PATTERN='"^[C]*,"'
PROGRAMS_FILE=~/.local/bin/system-setup/darwin/programs

blue=$(tput setaf 28)
cyan=$(tput setaf 12)
green=$(tput setaf 3)
red=$(tput setaf 1)
normal=$(tput sgr0)

function print_step() {
    printf "\n${green}${1}${normal}:\n"
}

function print_step_info() {
    printf "%-2s${cyan}${1}${normal}\n"
}

function configuration() {
    osascript -e 'tell application "System Preferences" to quit' # avoid possible conflicts

    print_step "setting system configurations"

    # activity monitor
    defaults write com.apple.ActivityMonitor IconType -int 5               # visualize cpu usage in the activity monitor dock icon
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true     # show the main window when launching activity monitor
    defaults write com.apple.ActivityMonitor ShowCategory -int 0           # show all processes in activity monitor
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" # sort activity monitor results by cpu usage
    defaults write com.apple.ActivityMonitor SortDirection -int 0          # sort activity monitor results by cpu usage
    print_step_info "activity monitor"

    # dock
    defaults write com.apple.dock autohide -bool true                # automatically hide and show the dock
    defaults write com.apple.dashboard mcx-disabled -bool true       # disable dashboard
    defaults write com.apple.dock autohide -bool true                # automatically hide and show the dock
    defaults write com.apple.dock autohide-delay -float 0            # remove the auto-hiding dock delay
    defaults write com.apple.dock autohide-time-modifier -float 0    # remove the animation when hiding/showing the dock
    defaults write com.apple.dock dashboard-in-overlay -bool true    # don’t show dashboard as a space
    defaults write com.apple.dock launchanim -bool false             # don’t animate opening applications from the dock
    defaults write com.apple.dock mru-spaces -bool false             # don’t automatically rearrange spaces based on most recent use
    defaults write com.apple.dock persistent-apps -array             # wipe all (default) app icons from the dock
    defaults write com.apple.dock show-recents -bool false           # don’t show recent applications in dock
    defaults write com.apple.dock showLaunchpadGestureEnabled -int 0 # disable the launchpad gesture (pinch with thumb and three fingers)
    defaults write com.apple.dock showhidden -bool true              # make dock icons of hidden applications translucent
    print_step_info "dock"

    # finder
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true     # avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.finder AppleShowAllFiles -bool true                 # show hidden files by default
    defaults write com.apple.finder DisableAllAnimations -bool true              # disable window animations and Get Info animations
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # disable the warning when changing a file extension
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"          # list view default
    defaults write com.apple.frameworks.diskimages skip-verify -bool true        # disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true # disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true # disable disk image verification
    print_step_info "finder"

    # system settings
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false             # disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 10                         # key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1                                 # key repeat rate
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false     # disable automatic capitalization as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false   # disable smart dashes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # disable automatic period substitution as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # disable smart quotes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # disable auto-correct
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true    # expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true   # expand save panel by default
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false       # disable 'natural scrolling'
    defaults write com.apple.LaunchServices LSQuarantine -bool false               # disable the “are you sure you want to open this application?” dialog
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true             # display full posix path as finder window title
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings \
        -dict-add "continuousSpellCheckingEnabled" \
        -bool false
    defaults write com.apple.screencapture location -string “$HOME/Desktop”                            # sreenshots saved to desktop
    defaults write com.apple.screencapture type -string “png”                                          # screenshots are png format
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null # disable notification center
    sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName              # reveal ip address, hostname, os version on login screen
    defaults write com.apple.CrashReporter DialogType -string "none"                                   # disable crash reporter
    print_step_info "system"

    find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete # reset launchpad excluding wallpaper

    for app in \
        "Activity Monitor" \
        "cfprefsd" \
        "Dock" \
        "Finder" \
        "SystemUIServer"; do
        #killall "${app}" &> /dev/null
        echo "$app"
    done
}

install_brew() {
    if ! which brew > /dev/null; then
        bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
        print_step "brew installed"
    else
        print_step "brew already installed"
    fi
}

function install_programs() {
    print_step "installing programs"
    brew bundle install --no-lock --file $PROGRAMS_FILE
}

prompt="\
${red}Mac setup requires your password
Password:${normal} "

sudo --prompt "${prompt}" --validate
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2> /dev/null &
print_step "configuring ${HOSTNAME}"
configuration
install_brew
install_programs
print_step "configured ${HOSTNAME}"
