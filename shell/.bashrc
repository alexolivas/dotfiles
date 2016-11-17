COLOR_TYPES=(00 01)
COLOR_CODES=(31 32 33 34 35 36)

U1=${COLOR_TYPES[$RANDOM % ${#COLOR_TYPES[@]} ]}
U2=${COLOR_CODES[$RANDOM % ${#COLOR_CODES[@]} ]}
H1=${COLOR_TYPES[$RANDOM % ${#COLOR_TYPES[@]} ]}
H2=${COLOR_CODES[$RANDOM % ${#COLOR_CODES[@]} ]}
S1=${COLOR_TYPES[$RANDOM % ${#COLOR_CODES[@]} ]}
S2=${COLOR_CODES[$RANDOM % ${#COLOR_CODES[@]} ]}

#######################################################
# Bash functions
#######################################################
function renametab () {
    echo -ne "\033]0;"$@"\007"
}

#######################################################
# Variables
#######################################################
# Path

# Set the different bin locations in your path
PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
[ -d "$HOME/Dropbox/bin" ] && PATH="$HOME/Dropbox/bin:$PATH"
export PATH=$PATH

# Virtualwrapper Environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
source /usr/local/bin/virtualenvwrapper.sh

# record only the most recent duplicated command
export HISTCONTROL=ignoreboth
export HISTIGNORE='pwd:ls:history:'
export HISTSIZE=4096

#######################################################
# Aliases
#######################################################

alias grep='grep --color=auto'
alias flushdns='sudo killall -HUP mDNSResponder'

###################################
# Hobsons specific aliases
###################################

# ORE Governor
alias ore_governor='renametab governor.ore && ssh -v governor.ore.starfishsolutions.com'

# IRL Governor
# alias irl_governor='renametab governor.irl && ssh -v governor.irl.starfishsolutions.com'