#!/bin/bash
. ~/.bashrc

#check for awscli
which aws > /dev/null
[ $? != 0 ] && echo "Requires awscli!" && exit 1

#check for percol
which percol > /dev/null
[ $? != 0 ] && echo "Requires percol!" && exit 1

#check for jq
which jq > /dev/null
[ $? != 0 ] && echo "Requires jq!" && exit 1

#get a list of instances
export AWS_DEFAULT_REGION="us-east-1"
INSTANCES=$(aws ec2 describe-instances --filters "Name=tag:Environment,Values=stage-rc" "Name=instance-state-name,Values=running")

NAMES=$(echo "${INSTANCES}" | jq '.Reservations[].Instances[].Tags[] | select(.Key == "Name").Value')

#present to percol
NAME=$(echo "${NAMES}" | percol)

NAME=$(echo ${NAME} | tr -d "\"") #strip quotes
rename "${NAME}"
#screen -X title "${NAME}"

INSTANCE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${NAME}")

IP=$(echo "${INSTANCE}" | jq '.Reservations[].Instances[].PrivateIpAddress')
echo "IP: [${IP}]" > ~/Downloads/test.txt
IP=$(echo $IP | tr -d "\"") #strip quotes

clear

#ssh
ssh ${IP}
