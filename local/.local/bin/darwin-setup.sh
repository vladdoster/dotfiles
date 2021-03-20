#! /bin/bash
set -e pipefail

IFS=$' \t\n' var=$* # make single string from multiple words
PROGRAMS_PATTERN='"^[C]*,"'
PROGRAMS_FILE=~/.local/bin/system-setup/darwin/programs

blue=$(tput setaf 28)
cyan=$(tput setaf 12)
green=$(tput setaf 3)
normal=$(tput sgr0)
red=$(tput setaf 1)

print_step() {
    printf "\n== ${green}${1}${normal}:\n"
}

print_step_info() {
    printf "---${cyan}${1}${normal}\n"
}

print_step_info() {
    printf "---${cyan}${1}${normal}\n"
}

configuration() {
    # Close any open System Preferences panes, to prevent them from overriding settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'
    # Ask for the administrator password upfront
    sudo -v
    # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2> /dev/null &
    ###############################################################################
    # General UI/UX                                                               #
    ###############################################################################
    sudo scutil --set ComputerName "0x6D746873" # Set computer name (as done via System Preferences → Sharing)
    sudo scutil --set HostName "0x6D746873"
    sudo scutil --set LocalHostName "0x6D746873"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
    sudo pmset -a standbydelay 86400                                            # Set standby delay to 24 hours (default is 1 hour)
    sudo nvram SystemAudioVolume=" "                                            # Disable the sound effects on boot
    defaults write com.apple.universalaccess reduceTransparency -bool true      # Disable transparency in the menu bar and elsewhere on Yosemite
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2             # Set sidebar icon size to medium
    defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false            # Disable the over-the-top focus ring animation
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001               # Increase window resize speed for Cocoa applications
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    defaults write com.apple.LaunchServices LSQuarantine -bool false                                                                                            # Disable the “Are you sure you want to open this application?” dialog
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
    defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true                                                                                       # Display ASCII control characters using caret notation in standard text views
    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false                                                                             # Disable Resume system-wide
    defaults write com.apple.CrashReporter DialogType -string "none"                                                                                            # Disable the crash reporter
    defaults write com.apple.helpviewer DevMode -bool true                                                                                                      # Set Help Viewer windows to non-floating mode
    echo "0x08000100:0" > ~/.CFUserTextEncoding                                                                                                                 # See https://github.com/mathiasbynens/dotfiles/issues/237
    sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName                                                                       # Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
    sudo systemsetup -setrestartfreeze on                                                                                                                       # Restart automatically if the computer freezes
    sudo systemsetup -setcomputersleep Off > /dev/null                                                                                                          # Never go into computer sleep mode
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null                                                          # Disable Notification Center and remove the menu bar icon
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false                                                                               # Disable smart quotes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false                                                                                # Disable smart dashes as they’re annoying when typing code
    rm -rf ~/Library/Application Support/Dock/desktoppicture.db                                                                                                 # all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
    sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
    sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg
    ################################################################################
    ## SSD-specific tweaks                                                         #
    ################################################################################
    sudo rm /private/var/vm/sleepimage           # Remove the sleep image file to save disk space
    sudo touch /private/var/vm/sleepimage        # Create a zero-byte file instead…
    sudo chflags uchg /private/var/vm/sleepimage # …and make sure it can’t be rewritten
    sudo pmset -a sms 0                          # Disable the sudden motion sensor as it’s not useful for SSDs
    ################################################################################
    #+# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
    #+###############################################################################
    # Trackpad: enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2 # Trackpad: map bottom right corner to right-click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false            # Disable “natural” (Lion-style) scrolling
    defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 # Increase sound quality for Bluetooth headphones/headsets
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                            # Enable full keyboard access for all controls
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true      # # Use scroll gesture with the Ctrl (^) modifier key to zoom
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
    defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true # # Follow the keyboard focus while zoomed in
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false            # Disable press-and-hold for keys in favor of key repeat
    defaults write NSGlobalDomain KeyRepeat -int 1                                # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain InitialKeyRepeat -int 10
    defaults write NSGlobalDomain AppleLanguages -array "en" # Set language and text formats
    defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
    defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
    defaults write NSGlobalDomain AppleMetricUnits -bool false
    sudo systemsetup -settimezone "America/New York" > /dev/null                      # Set the timezone; see `sudo systemsetup -listtimezones` for other values
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false    # Disable auto-correct
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null # Stop iTunes from responding to the keyboard media keys
    ################################################################################
    ## Screen                                                                      #
    ################################################################################
    defaults write com.apple.screensaver askForPassword -int 1 # Require password immediately after sleep or screen saver begins
    defaults write com.apple.screensaver askForPasswordDelay -int 0
    defaults write com.apple.screencapture location -string "${HOME}/Desktop"                           # Save screenshots to the desktop
    defaults write com.apple.screencapture type -string "png"                                           # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
    defaults write com.apple.screencapture disable-shadow -bool true                                    # Disable shadow in screenshots
    defaults write NSGlobalDomain AppleFontSmoothing -int 2                                             # Enable subpixel font rendering on non-Apple LCDs
    sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true # Enable HiDPI display modes (requires restart)
    ################################################################################
    ## Finder                                                                      #
    ################################################################################
    defaults write com.apple.finder QuitMenuItem -bool true         # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
    defaults write com.apple.finder DisableAllAnimations -bool true # Finder: disable window animations and Get Info animations
    defaults write com.apple.finder NewWindowTarget -string "PfDe"  # For other paths, use `PfLo` and `file:///full/path/here/`
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true # Show icons for hard drives, servers, and removable media on the desktop
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true                 # Finder: show hidden files by default
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true              # Finder: show all filename extensions
    defaults write com.apple.finder ShowStatusBar -bool true                     # Finder: show status bar
    defaults write com.apple.finder ShowPathbar -bool true                       # Finder: show path bar
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true           # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXSortFoldersFirst -bool true               # Keep folders on top when sorting by name
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # Disable the warning when changing a file extension
    defaults write NSGlobalDomain com.apple.springing.enabled -bool true         # Enable spring loading for directories
    defaults write NSGlobalDomain com.apple.springing.delay -float 0             # Remove the spring loading delay for directories
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
    defaults write com.apple.frameworks.diskimages skip-verify -bool true # Disable disk image verification
    defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
    defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist # Show item info near icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist # Show item info to the right of the icons on the desktop
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist     # Enable snap-to-grid for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist # Increase grid spacing for icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist # Increase the size of icons on the desktop and in other icon views
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"            # Use list view in all Finder windows by default
    defaults write com.apple.finder WarnOnEmptyTrash -bool false                   # # Disable the warning before emptying the Trash
    defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true         # Enable AirDrop over Ethernet and on unsupported Macs running Lion
    sudo nvram boot-args="mbasd=1"                                                 # Enable the MacBook Air SuperDrive on any Mac
    chflags nohidden ~/Library                                                     # Show the ~/Library folder
    sudo chflags nohidden /Volumes                                                 # Show the /Volumes folder
    file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns # Remove Dropbox’s green checkmark icons in Finder
    [ -e "${file}" ] && mv -f "${file}" "${file}.bak"
    defaults write com.apple.finder FXInfoPanesExpanded -dict \ # Expand the following File Info panes:
    General -bool true \
        OpenWith -bool true \
        Privileges -bool true
    ################################################################################
    # Dock, Dashboard, and hot corners                                            #
    ################################################################################
    defaults write com.apple.dock mouse-over-hilite-stack -bool true                   # Enable highlight hover effect for the grid view of a stack (Dock)
    defaults write com.apple.dock tilesize -int 36                                     # Set the icon size of Dock items to 36 pixels
    defaults write com.apple.dock mineffect -string "scale"                            # Change minimize/maximize window effect
    defaults write com.apple.dock minimize-to-application -bool false                  # Minimize windows into their application’s icon
    defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true   # Enable spring loading for all Dock items
    defaults write com.apple.dock show-process-indicators -bool true                   # Show indicator lights for open applications in the Dock
    defaults write com.apple.dock persistent-apps -array                               # Wipe all (default) app icons from the Dock
    defaults write com.apple.dock static-only -bool true                               # Show only open applications in the Dock
    defaults write com.apple.dock launchanim -bool false                               # Don’t animate opening applications from the Dock
    defaults write com.apple.dock expose-animation-duration -float 0.1                 # Speed up Mission Control animations
    defaults write com.apple.dashboard mcx-disabled -bool true                         # Disable Dashboard
    defaults write com.apple.dock dashboard-in-overlay -bool true                      # Don’t show Dashboard as a Space
    defaults write com.apple.dock mru-spaces -bool false                               # Don’t automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock autohide-delay -float 0                              # Remove the auto-hiding Dock delay
    defaults write com.apple.dock autohide-time-modifier -float 0                      # Remove the animation when hiding/showing the Dock
    defaults write com.apple.dock autohide -bool true                                  # Automatically hide and show the Dock
    defaults write com.apple.dock showhidden -bool true                                # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showLaunchpadGestureEnabled -int 0                   # Disable the Launchpad gesture (pinch with thumb and three fingers)
    find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete # Reset Launchpad, but keep the desktop wallpaper intact
    defaults write com.apple.dock wvous-tl-corner -int 3
    defaults write com.apple.dock wvous-tl-modifier -int 3
    defaults write com.apple.dock wvous-tr-corner -int 3 # Top right screen corner → Desktop
    defaults write com.apple.dock wvous-tr-modifier -int 3
    defaults write com.apple.dock wvous-bl-corner -int 3 # Bottom left screen corner → Start screen saver
    defaults write com.apple.dock wvous-bl-modifier -int 3
    ##############################################################################
    # Mail                                                                        #
    ###############################################################################
    defaults write com.apple.mail DisableReplyAnimations -bool true # Disable send and reply animations in Mail.app
    defaults write com.apple.mail DisableSendAnimations -bool true
    defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false                           # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
    defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"                        # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
    defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes" # Display emails in threaded mode, sorted by date (oldest at the top)
    defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
    defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
    defaults write com.apple.mail DisableInlineAttachmentViewing -bool true              # Disable inline attachments (just show the icons)
    defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled" # Disable automatic spell checking
    ###############################################################################
    # Terminal & iTerm 2                                                          #
    ###############################################################################
    defaults write com.apple.terminal StringEncodings -array 4 # Only use UTF-8 in Terminal.app
    ###############################################################################
    # Time Machine                                                                #
    ###############################################################################
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true # Prevent Time Machine from prompting to use new hard drives as backup volume
    ###############################################################################
    # Activity Monitor                                                            #
    ###############################################################################
    defaults write com.apple.ActivityMonitor OpenMainWindow -bool true     # Show the main window when launching Activity Monitor
    defaults write com.apple.ActivityMonitor IconType -int 5               # Visualize CPU usage in the Activity Monitor Dock icon
    defaults write com.apple.ActivityMonitor ShowCategory -int 0           # Show all processes in Activity Monitor
    defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" # Sort Activity Monitor results by CPU usage
    defaults write com.apple.ActivityMonitor SortDirection -int 0
    ###############################################################################
    # Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
    ###############################################################################
    defaults write com.apple.addressbook ABShowDebugMenu -bool true # Enable the debug menu in Address Book
    defaults write com.apple.dashboard devmode -bool true           # Enable Dashboard dev mode (allows keeping widgets on the desktop)
    defaults write com.apple.TextEdit RichText -int 0               # Use plain text mode for new TextEdit documents
    defaults write com.apple.TextEdit PlainTextEncoding -int 4      # Open and save files as UTF-8 in TextEdit
    defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
    defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true # Enable the debug menu in Disk Utility
    defaults write com.apple.DiskUtility advanced-image-options -bool true
    defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true # Auto-play videos when opened with QuickTime Player
    ###############################################################################
    # Mac App Store                                                               #
    ###############################################################################
    defaults write com.apple.appstore WebKitDeveloperExtras -bool true       # Enable the WebKit Developer Tools in the Mac App Store
    defaults write com.apple.appstore ShowDebugMenu -bool true               # Enable Debug Menu in the Mac App Store
    defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true # Enable the automatic update check
    defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1         # Check for software updates daily, not just once per week
    defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1         # Download newly available updates in background
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1     # Install System data files & security updates
    defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1         # Automatically download apps purchased on other Macs
    defaults write com.apple.commerce AutoUpdate -bool true                  # Turn on app auto-update
    ###############################################################################
    # Photos                                                                      #
    ###############################################################################
    defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true # Prevent Photos from opening automatically when devices are plugged in
    ###############################################################################
    # Messages                                                                    #
    ###############################################################################
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false # Disable automatic emoji substitution (i.e. use plain text smileys)
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false         # Disable smart quotes as it’s annoying for messages that contain code
    defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false            # Disable continuous spell checking
    ###############################################################################
    # Google Chrome & Google Chrome Canary                                        #
    ###############################################################################
    defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false # Disable the all too sensitive backswipe on trackpads
    defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false # Disable the all too sensitive backswipe on Magic Mouse
    defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false
    defaults write com.google.Chrome DisablePrintPreview -bool true # Use the system-native print preview dialog
    defaults write com.google.Chrome.canary DisablePrintPreview -bool true
    defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true # Expand the print dialog by default
    defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
    ###############################################################################
    # GPGMail 2                                                                   #
    ###############################################################################
    defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false # Disable signing emails by default
    ################################################################################
    # Transmission.app                                                            #
    ###############################################################################
    defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true # Use `~/Documents/Torrents` to store incomplete downloads
    defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Documents/Torrents"
    defaults write org.m0k.transmission DownloadAsk -bool false # Don’t prompt for confirmation before downloading
    defaults write org.m0k.transmission MagnetOpenAsk -bool false
    defaults write org.m0k.transmission DeleteOriginalTorrent -bool true # Trash original torrent files
    defaults write org.m0k.transmission WarningDonate -bool false        # Hide the donate message
    defaults write org.m0k.transmission WarningLegal -bool false         # Hide the legal disclaimer
    defaults write org.m0k.transmission BlocklistNew -bool true          # IP block list -- source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
    defaults write org.m0k.transmission BlocklistURL -string "http://john.bitsurge.net/public/biglist.p2p.gz"
    defaults write org.m0k.transmission BlocklistAutoUpdate -bool true
    ###############################################################################
    # Kill affected applications                                                  #
    ###############################################################################
    for APP in "Activity Monitor" \
        "Address Book" \
        "Calendar" \
        "Contacts" \
        "cfprefsd" \
        "Dock" \
        "Finder" \
        "Google Chrome" \
        "Google Chrome Canary" \
        "Mail" \
        "Messages" \
        "Photos" \
        "SystemUIServer" \
        "Terminal" \
        "Transmission"; do
        killall "${APP}" &> /dev/null
    done
    echo "Done. Note that some of these changes require a logout/restart to take effect."
}

install_brew() {
    if ! which brew > /dev/null; then
        bash -c $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
        print_step "brew installed"
    else
        print_step "ERROR: homebrew already installed"
    fi
}

function install_programs() {
    if [[ ! -e $PROGRAMS_FILE ]]; then
        print_step "ERROR: brew programs file not found"
    else
        print_step "installing programs"
        brew bundle install --no-lock --file ${PROGRAMS_FILE}
    fi
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
