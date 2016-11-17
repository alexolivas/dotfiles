#!/usr/bin/env bash

#############################################################################################
# Screen shots
#############################################################################################

defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"


##########################################################################
# Activity Monitor
##########################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0


#####################################################################
# Finder
#####################################################################

# Show hidden files and file extensions by default
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true