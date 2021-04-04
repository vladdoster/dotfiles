#!/bin/bash

###############################################################################
# Setup                                                               #
###############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
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
# Configure                                                                   #
###############################################################################
# Set computer name (as done via System Preferences → Sharing)
_HOSTNAME="$(openssl rand -hex 8)"
sudo scutil --set ComputerName "$_HOSTNAME"
sudo scutil --set HostName "$_HOSTNAME"
sudo scutil --set LocalHostName "$_HOSTNAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$_HOSTNAME"
###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true           # Follow the keyboard focus while zoomed in
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false                      # Disable press-and-hold for keys in favor of key repeat
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true # Show language menu in the top right corner of the boot screen
sudo systemsetup -settimezone "America/New York" > /dev/null                            # Set the timezone; see `sudo systemsetup -listtimezones` for other values
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null       # Stop iTunes from responding to the keyboard media keys
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false                # Disable “natural” (Lion-style) scrolling
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40     # Increase sound quality for Bluetooth headphones/headsets
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                                # Enable full keyboard access for all controls
# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false
##############################################################################
# Finder                                                                      #
###############################################################################
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library      # Show the ~/Library folder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true         # Display full POSIX path as Finder window title
defaults write com.apple.finder _FXSortFoldersFirst -bool true             # Keep folders on top when sorting by name
defaults write com.apple.finder AppleShowAllFiles -bool true               # Finder: show hidden files by default
defaults write com.apple.finder DisableAllAnimations -bool true            # Finder: disable window animations and Get Info animations
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"        # When performing a search, search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # Disable the warning when changing a file extension
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"        # Use list view in all Finder windows by default
defaults write com.apple.finder QuitMenuItem -bool true                    # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder ShowPathbar -bool true                     # Finder: show path bar
defaults write com.apple.finder ShowStatusBar -bool true                   # Finder: show status bar
defaults write com.apple.finder WarnOnEmptyTrash -bool false               # Disable the warning before emptying the Trash
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true     # Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write NSGlobalDomain AppleShowAllExtensions -bool true            # Finder: show all filename extensions
defaults write NSGlobalDomain com.apple.springing.delay -float 0           # Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true       # Enable spring loading for directories
sudo chflags nohidden /Volumes                                             # Show the /Volumes folder
# Set $HOME as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"
# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "$file" ] && mv -f "$file" "$file.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true
###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
defaults write com.apple.dashboard mcx-disabled -bool true                       # Disable Dashboard
defaults write com.apple.dock autohide -bool true                                # Automatically hide and show the Dock
defaults write com.apple.dock autohide-delay -float 0                            # Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0                    # Remove the animation when hiding/showing the Dock
defaults write com.apple.dock dashboard-in-overlay -bool true                    # Don’t show Dashboard as a Space
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true # Enable spring loading for all Dock items
defaults write com.apple.dock expose-animation-duration -float 0.1               # Speed up Mission Control animations
defaults write com.apple.dock expose-group-by-app -bool false                    # Don’t group windows by application in Mission Control
defaults write com.apple.dock launchanim -bool false                             # Don’t animate opening applications from the Dock
defaults write com.apple.dock mineffect -string "scale"                          # Change minimize/maximize window effect
defaults write com.apple.dock minimize-to-application -bool true                 # Minimize windows into their application’s icon
defaults write com.apple.dock mouse-over-hilite-stack -bool true                 # Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mru-spaces -bool false                             # Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock persistent-apps -array                             # Wipe all app icons from the Dock
defaults write com.apple.dock show-process-indicators -bool true                 # Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-recents -bool false                           # Don’t show recent applications in Dock
defaults write com.apple.dock showhidden -bool true                              # Make Dock icons of hidden applications translucent
defaults write com.apple.dock tilesize -int 36                                   # Set the icon size of Dock items to 36 pixels
find "$HOME/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete # Reset Launchpad, but keep the desktop wallpaper intact
defaults write com.apple.dock wvous-tl-corner -int 2                             # Top left screen corner - Mission Control
defaults write com.apple.dock wvous-tl-modifier -int 0                           # Top left screen corner - Mission Control
defaults write com.apple.dock wvous-tr-corner -int 4                             # Top right screen corner Mission Control
defaults write com.apple.dock wvous-tr-modifier -int 0                           # Top right screen corner Mission Control
defaults write com.apple.dock wvous-bl-corner -int 5                             # Bottom left screen corner Mission Control
defaults write com.apple.dock wvous-bl-modifier -int 0                           # Bottom left screen corner Mission Control
###############################################################################
# Google Chrome                                                               #
###############################################################################
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false             # Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false      # Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false        # Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false # Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome DisablePrintPreview -bool true                              # Use the system-native print preview dialog
defaults write com.google.Chrome.canary DisablePrintPreview -bool true                       # Use the system-native print preview dialog
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true                 # Expand the print dialog by default
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true          # Expand the print dialog by default
###############################################################################
# Visual Studio Code                                                          #
###############################################################################
printf "⚙️ Put Visual Studio Code in quarantine to install plugins...\n"
xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
printf "📦 Install Visual Studio Code plugins...\n"
open -a "Visual Studio Code"
code --install-extension DavidAnson.vscode-markdownlint
code --install-extension HookyQR.beautify
code --install-extension Tyriar.sort-lines
code --install-extension ms-python.python
code --install-extension yzhang.markdown-all-in-one

# Configure macOS Finder
printf "⚙️ Configure Finder...\n"
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
defaults write com.apple.finder ShowPathbar -bool true
chflags nohidden ~/Library
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Configure macOS Screen Capture
printf "⚙️ %s...\n" "Save screenshots in PNG format"
mkdir ~/Pictures/Screenshots
defaults write com.apple.screencapture location -string "~/Desktop"
defaults write com.apple.screencapture type -string "png"

# Configure macOS Keyboard
printf "⚙️ %s...\n" "Configure Keyboard"
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

# Configure macOS TextEdit
printf "⚙️ %s...\n" "Configure TextEdit"
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Configure macOS Trackpad
printf "⚙️ %s...\n" "Configure Trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Configure macOS
printf "⚙️ %s...\n" "Various configuration"
defaults write com.apple.gamed Disabled -bool true
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
###############################################################################
# Kill affected applications                                                  #
###############################################################################
for app in "Activity Monitor" \
    "Address Book" \
    "Calendar" \
    "cfprefsd" \
    "Contacts" \
    "Dock" \
    "Finder" \
    "Google Chrome" \
    "Mail" \
    "Messages" \
    "Photos" \
    "Safari" \
    "SystemUIServer" \
    "Terminal" \
    "Transmission"; do
    killall "$app" &> /dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

# Create Projects directory
printf "⚙️ %s...\n" "Create Projects directory"
mkdir "$HOME"/code
chmod 755 "$HOME"/code

# Cleanup
printf "⚙️ %s...\n" "Cleanup and final touches"
brew update \
    && brew upgrade \
    && brew cleanup --prune=2 \
    && brew doctor

# Exit script
exit
