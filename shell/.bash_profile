# This file is executed every time you login
# TODO: Add Load average, memory usage info here to get this each time you login for the first time

if [ -f ~/.bashrc ]; then
   . ~/.bashrc
fi

export JAVA_HOME=$(/usr/libexec/java_home)
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_67.jdk/Contents/Home"