#!/usr/bin/env bash

# Always open everything in Finder's list view.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder
chflags nohidden ~/Library

# Configure terminal default theme
defaults write com.apple.terminal "Default Window Settings" -string "Homebrew"
defaults write com.apple.terminal "Startup Window Settings" -string "Homebrew"

# Hide Safari's bookmark bar
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Setup Safari for development
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safar.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true