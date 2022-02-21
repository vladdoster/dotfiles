#!/usr/bin/env zsh
#
# Close open System Preferences panes preventing overriding changed settings
#
function error() { print -P "%F{160}[ERROR] ---%f%b $1" >&2 && exit 1; }
function user_input() { print -P "%F{20} ---%f%b $1" >&2 && exit 1; }
function info() { print -P "%F{34}[INFO] ---%f%b $1"; }
osascript -e 'tell application "System Preferences" to quit' # Ask for the administrator password upfront
sudo -v
while true; do # Keep-alive: update existing `sudo` time stamp until finished
	sudo -n true && sleep 60 && kill -0 "$$" || exit 1
done 2>/dev/null &
#== GENERAL UI/UX                                                               #
info "Updating general system settings"
sudo nvram SystemAudioVolume=" "                                                       # Disable the sound effects on boot
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600" # Set highlight color to green
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2                        # Set sidebar icon size to medium
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"                     # Always show scrollbars
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false                       # Disable the over-the-top focus ring animation
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0                 # Adjust toolbar title rollover delay
defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false                     # Disable smooth scrolling
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001                          # Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true            # Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true # Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false           # Save to disk (not to iCloud) by default
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true          # Automatically quit printer app once the print jobs complete
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true                 # Display ASCII control characters using caret notation in standard text views
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false               # Disable automatic termination of inactive apps
defaults write com.apple.CrashReporter DialogType -string "none"                      # Disable the crash reporter
defaults write com.apple.helpviewer DevMode -bool true                                # Set Help Viewer windows to non-floating mode
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName # Reveal IP address, hostname, OS version, etc. in login window
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false            # Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false          # Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false        # Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false         # Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false        # Disable auto-correct
# disable the “are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool true
# remove duplicates in the “open with” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
#== TRACKPAD, MOUSE, KEYBOARD, BLUETOOTH ACCESSORIES, AND INPUT                 #
info "updating trackpad, mouse, keyboard, and bluetooth settings"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true # Trackpad: enable tap to click for this user and for the login screen
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2 # Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false            # Disable “natural” (Lion-style) scrolling
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40 # Increase sound quality for Bluetooth headphones/headsets
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                            # Enable full keyboard access for all controls
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true      # Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true # Follow the keyboard focus while zoomed in
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false            # Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain KeyRepeat -int 1                                # Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain AppleLanguages -array "en" # Set language and text formats
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false
#== SCREEN                                                                      #
info "Updating display settings"
defaults write com.apple.screensaver askForPassword -int 1 # Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screencapture location -string "$HOME/Desktop"                             # Save screenshots to the desktop
defaults write com.apple.screencapture type -string "png"                                           # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture disable-shadow -bool true                                    # Disable shadow in screenshots
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true # Enable subpixel font rendering on non-Apple LCDs
#== FINDER                                                                      #
info "Updating finder settings"
defaults write com.apple.finder QuitMenuItem -bool true         # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder DisableAllAnimations -bool true # Finder: disable window animations and Get Info animations
defaults write com.apple.finder NewWindowTarget -string "PfDe"  # Set Desktop as the default location for new Finder windows
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME"
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
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"          # When performing a search, search the current folder by default
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false   # Disable the warning when changing a file extension
defaults write NSGlobalDomain com.apple.springing.enabled -bool true         # Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0             # Remove the spring loading delay for directories
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.frameworks.diskimages skip-verify -bool true # Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true # Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"            # Use list view in all Finder windows by default
defaults write com.apple.finder WarnOnEmptyTrash -bool false                   # Disable the warning before emptying the Trash
sudo chflags nohidden /Volumes                                                 # Show the /Volumes folder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns # Remove Dropbox’s green checkmark icons in Finder
# show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
# enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
[ -e "$file" ] && mv -f "$file" "$file.bak"
# expand the following file info panes
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true
# DOCK, DASHBOARD, AND HOT CORNERS
info "updating dock, dashboard, and hot corner settings"
defaults write com.apple.dashboard mcx-disabled -bool true                        # Disable Dashboard
defaults write com.apple.dock autohide -bool true                                 # Automatically hide and show the Dock
defaults write com.apple.dock autohide-delay -float 0                             # Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-time-modifier -float 0                     # Remove the animation when hiding/showing the Dock
defaults write com.apple.dock dashboard-in-overlay -bool true                     # Don’t show Dashboard as a Space
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool false # Enable spring loading for all Dock items
defaults write com.apple.dock expose-animation-duration -float 0.1                # Speed up Mission Control animations
defaults write com.apple.dock expose-group-by-app -bool false                     # Don’t group windows by application in Mission Control
defaults write com.apple.dock launchanim -bool false                              # Don’t animate opening applications from the Dock
defaults write com.apple.dock mineffect -string "scale"                           # Change minimize/maximize window effect
defaults write com.apple.dock minimize-to-application -bool true                  # Minimize windows into their application’s icon
defaults write com.apple.dock mouse-over-hilite-stack -bool true                  # Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mru-spaces -bool false                              # Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock show-process-indicators -bool true                  # Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-recents -bool false                            # Don’t show recent applications in Dock
defaults write com.apple.dock showhidden -bool true                               # Make Dock icons of hidden applications translucent
defaults write com.apple.dock tilesize -int 72                                    # Set the icon size of Dock items to 36 pixels
find "$HOME/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete  # Reset Launchpad, but keep the desktop wallpaper intact
defaults write com.apple.dock wvous-bl-corner -int 2                              # Bottom left
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-tl-corner -int 2 # All corners → Mission Control
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 2 # Top right screen corner
defaults write com.apple.dock wvous-tr-modifier -int 0
# SAFARI & WEBKIT
info "updating safari and webkit settings"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true                  # Add a context menu item for showing the Web Inspector in web views
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false     # Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari IncludeDevelopMenu -bool true                   # Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true             # Enable Safari’s debug menu
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true # Update extensions automatically
defaults write com.apple.Safari ProxiesInBookmarksBar "()"                      # Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true             # Enable “Do Not Track”
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true        # Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
defaults write com.apple.Safari UniversalSearchEnabled -bool false                # Privacy: don’t send search queries to Apple
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false # Disable auto-correct
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true      # Enable continuous spellchecking
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false                                     # Block pop-up windows
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true                                                    # Press Tab to highlight each item on a web page
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true # Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
# Mail                                                                        #
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false # Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true    # Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableReplyAnimations -bool true            # Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableSendAnimations -bool true
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes" # Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"        # Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled" # Disable automatic spell checking
# TERMINAL
defaults write com.apple.Terminal ShowLineMarks -int 0           # Disable the annoying line marks
defaults write com.apple.terminal FocusFollowsMouse -bool true   # Enable “focus follows mouse” for Terminal.app and all X11 apps
defaults write com.apple.terminal SecureKeyboardEntry -bool true # Enable Secure Keyboard Entry in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4       # Only use UTF-8 in Terminal.app
defaults write org.x.X11 wm_ffm -bool true
# ACTIVITY MONITOR
defaults write com.apple.ActivityMonitor IconType -int 5               # Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true     # Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0           # Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage" # Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor SortDirection -int 0
# ADDRESS BOOK, DASHBOARD, ICAL, TEXTEDIT, AND DISK UTILITY
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true # Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility advanced-image-options -bool true
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool false # Disable auto-play videos when opened with QuickTime Player
defaults write com.apple.TextEdit PlainTextEncoding -int 4              # Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
defaults write com.apple.TextEdit RichText -int 0     # Use plain text mode for new TextEdit documents
defaults write com.apple.dashboard devmode -bool true # Enable Dashboard dev mode (allows keeping widgets on the desktop)
# KILL AFFECTED APPLICATIONS                                                  #
for application in \
	"Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"Terminal" \
	"Vivaldi" \
	"cfprefsd"; do
	killall "$application" &>/dev/null
done
info "successfully applied configuration options"
user_input "Reboot $HOSTNAME?[y/N]: " # Prompt user to reboot
read -r REBOOT
if [[ $REBOOT == "y" ]]; then
	info "rebooting in 5 seconds..."
	sleep 5
	sudo reboot
fi
info "skipping reboot"
exit 0
