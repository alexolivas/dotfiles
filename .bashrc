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
export PATH="/usr/local/bin:~/bin:$PATH"

# Virtualwrapper Environment
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development/Workspace
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

#########################
# Hobsons aliases
#########################
# ORE Governor
alias ore_governor='renametab governor.ore && ssh -v governor.ore.starfishsolutions.com'

# -------------------------------------------------------------------------------------------------------------
# Connect to these once you're SSH'd into the ORE Governor (running these outside the governor does not work)
# -------------------------------------------------------------------------------------------------------------
alias ore_web1_ea='renametab web1-ea.ore && ssh -v web1-ea.ore.starfishsolutions.com'
alias ore_web2_ea='renametab web2-ea.ore && ssh -v web2-ea.ore.starfishsolutions.com'

alias ore_ea='renametab db1.ore && ssh -f -N db1.ore && psql -h localhost -p 10000 -U starfish -d ea_ore'
alias ore_sfadmin_ea='renametab sfadmin-db1.ore && ssh -f -N sfadmin-db1.ore && psql -h localhost -p 10001 -U starfish -d sfadmin_ea_ore'
alias ore_ccsf_test='renametab ccsf-test.db && ssh -f -N ccsf-test.db && psql -h localhost -p 10003 -U starfish -d ccsf_test'
alias ore_4cd_test='renametab 4cd-test.db && ssh -f -N 4cd-test.db && psql -h localhost -p 10004 -U starfish -d 4cd_test'
alias ore_scccd_test='renametab scccd-test.db && ssh -f -N scccd-test.db && psql -h localhost -p 10005 -U starfish -d scccd_test'
alias ore_elcamino_test='renametab elcamino-test.db && ssh -f -N elcamino-test.db && psql -h localhost -p 10006 -U starfish -d elcamino_test'
alias ore_vvc_test='renametab vvc-test.db && ssh -f -N vvc-test.db && psql -h localhost -p 10007 -U starfish -d vvc_test'
alias ore_santarosa_test='renametab santarosa-test.db && ssh -f -N santarosa-test.db && psql -h localhost -p 10008 -U starfish -d santarosa_test'
alias ore_sbccd_test='renametab sbccd-test.db && ssh -f -N sbccd-test.db && psql -h localhost -p 10009 -U starfish -d sbccd_test'
alias ore_ea_ash='renametab ea-ash.db && ssh -f -N ea-ash.db && psql -h localhost -p 10010 -U starfish -d ea_ash'

# TEST: This one is different than the alias command above
alias ore_ea2_ash='renametab ea2-ash.db && psql -U starfish -d ea2_ash -h ea2-ash.db.starfishsolutions.com'

# TO Connect to the ops db run the following:
psql -U starfish -d ops_ore -h db2.ore.starfishsolutions.com


alias ore_ops='renametab db2.ore && ssh -f -N db2.ore && psql -h localhost -p 10011 -U starfish -d ea_ore'
alias ore_sfadmin_ops='renametab sfadmin-db2.ore && ssh -f -N sfadmin-db2.ore && psql -h localhost -p 10012 -U starfish -d sfadmin_ea_ore'

# SJC
alias sjc_web3='renametab web3.sjc && ssh web3.sjc.starfishsolutions.com'
alias sjc_web4='renametab web4.sjc && ssh web4.sjc.starfishsolutions.com'
alias sjc_web5='renametab web5.sjc && ssh web5.sjc.starfishsolutions.com'
alias sjc_web6='renametab web6.sjc && ssh web6.sjc.starfishsolutions.com'
alias sjc_db4='renametab db4.sjc && ssh db4.sjc.starfishsolutions.com'
alias sjc_db5='renametab db5.sjc && ssh db5.sjc.starfishsolutions.com'
alias sjc_db6='renametab db6.sjc && ssh db6.sjc.starfishsolutions.com'
alias sjc_db7='renametab db7.sjc && ssh db7.sjc.starfishsolutions.com'
alias sjc_db8='renametab db8.sjc && ssh db8.sjc.starfishsolutions.com'
alias sjc_db9='renametab db9.sjc && ssh db9.sjc.starfishsolutions.com'
alias sjc_db10='renametab db10.sjc && ssh db10.sjc.starfishsolutions.com'
alias sjc_db11='renametab db11.sjc && ssh db11.sjc.starfishsolutions.com'

# ASH
alias ash_web1='renametab web1.ash && ssh web1.ash.starfishsolutions.com'
alias ash_web2='renametab web2.ash && ssh web2.ash.starfishsolutions.com'
alias ash_web3='renametab web3.ash && ssh web3.ash.starfishsolutions.com'
alias ash_web4='renametab web4.ash && ssh web4.ash.starfishsolutions.com'
alias ash_db2='renametab db2.ash && ssh db2.ash.starfishsolutions.com'
alias ash_db3='renametab db3.ash && ssh db3.ash.starfishsolutions.com'
alias ash_db4='renametab db4.ash && ssh db4.ash.starfishsolutions.com'
alias ash_db5='renametab db5.ash && ssh db5.ash.starfishsolutions.com'
alias ash_db6='renametab db6.ash && ssh db6.ash.starfishsolutions.com'
alias ash_db7='renametab db7.ash && ssh db7.ash.starfishsolutions.com'
alias ash_db8='renametab db8.ash && ssh db8.ash.starfishsolutions.com'

# IRL
alias irl_web1='renametab web1.irl && ssh web1.irl.external.starfishsolutions.com'
alias irl_web2='renametab web2.irl && ssh web2.irl.external.starfishsolutions.com'
alias irl_db1='renametab db1.irl && ssh -f -N db1.irl && psql -h localhost -p 12000 -U starfish -d ea_irl'
alias irl_db2='renametab db2.irl && ssh -f -N db2.irl && psql -h localhost -p 12001 -U starfish -d ops_irl'

# STAGING
alias stage='renametab stage && ssh stage.starfishsolutions.com'
alias stage_rc='renametab stage-rc && ssh stage-rc.starfishsolutions.com'
alias stage_ea='renametab stage-ea && ssh stage-ea.starfishsolutions.com'
alias stage_ops='renametab stage-ops && ssh stage-ops.starfishsolutions.com'
alias stage_db='renametab stage db && ssh -f -N stage.db && psql -h localhost -p 9000 -U starfish -d stage'
alias stage_rc_db='renametab stage-rc db && ssh -f -N stage-rc.db && psql -h localhost -p 9001 -U starfish -d stage_rc'
alias stage_ea_db='renametab stage-ea db && ssh -f -N stage-ea.db && psql -h localhost -p 9002 -U starfish -d stage_ea'
alias stage_ops_db='renametab stage-ops db && ssh -f -N stage-ops.db && psql -h localhost -p 9003 -U starfish -d stage_ops'

