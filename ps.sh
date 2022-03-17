#!/bin/bash

fmt="%-9s%-5s%-5s%-10s%-100s\n"
printf "$fmt" PID TTY STAT TIME COMMAND

for proc in `ls /proc/ | egrep "^[0-9]" | sort -n`
do

   if [[ -f /proc/$proc/status ]]
       then
       PID=$proc

    TTY=`ls -all /proc/$proc/fd | grep /dev/ | head -1 | cut -f 11 -d ' ' | sed -r 's/.{,5}//'`
    if [[ TTY=null ]]
        then
        TTY="?"
    fi
    STAT=`cat /proc/$proc/status | awk '/State/{print $2}'`

    stime=`cut /proc/$proc/stat -f 15 -d ' '`
    utime=`cut /proc/$proc/stat -f 14 -d ' '`
    cutime=`cut /proc/$proc/stat -f 16 -d ' '`
    cstime=`cut /proc/$proc/stat -f 17 -d ' '`
    let "TIME=$stime+$utime+$cutime+$cstime"
    TIK=`getconf CLK_TCK`
    let "TIME=$TIME/$TIK"

     COMMAND=`tr -d '\0' < /proc/$proc/cmdline`
     if  [[ -z  "$COMMAND" ]]
          then
       COMMAND="[`awk '/Name/{print $2}' /proc/$proc/status`]"
#     else
#       COMMAND=`tr -d '\0' < /proc/1/cmdline `
     fi
    printf "$fmt" $PID $TTY  $STAT $TIME "$COMMAND" 
   fi
done
