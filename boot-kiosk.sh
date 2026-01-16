#!/bin/bash

# Be sure to set the path to your '.kiosk.cfg' file, by default it's looking to the users home directory
CFG=$HOME/.kiosk.cfg

# Here we'll load the contents of the '.kiosk.cfg' file, allows us to keep variables consistant and reuable
source ${CFG}

# If the old run file is left over, clear it out so we can create a new one. This file is used to track
# which URL we're displaying and what the refresh schedule is for that page.
if [ !f ${RUNFILE} ] ;then
    rm -f ${RUNFILE}
fi

echo ${BASHPID} > ${RUNFILE}

function refreshloop()
{
    echo ${BASHPID} > ${RUNFILE}

    while true; #create an infinite loop to refresh
    do
        # This creates a loop to initiate refreshes of the browser window. If in 'kiosk.cfg' you have REFRESH set to NONE
        # then no refresh is performed, however this will still loop looking at the config file incase you update it with
        # a value, then the refresh will be performed on that time schedule.

        REFRESH=`grep -i "^REFRESH=" ${CFG} | sed 's/^REFRESH=//'`

        if [ "${REFRESH}" = "0" ]; then
            sleep 20
        else
            sleep ${REFRESH}
            # This sends the CTRL+F5 keystroke to the foreground app, hopefully it's your browser.
            xdotool key ctrl+F5 & #you need to have xdotools installed
        fi
    done

    echo ${BASHPID} > ${RUNFILE}
}

function startbrowser()
{
    # Get the first URL from our URLFILE and open it initially
    URL=`cat ${URLFILE} | grep -v "#" | head -1 | awk -F, '{print $3}'`

    ${BROWSER} ${URL} --kiosk --noerrdialogs --disable-session-crashed-bubble --disable-infobars &

    echo ${BASHPID} > ${RUNFILE}
}

function startwebui()
{
    # Start up the simple webui
    ${WEBUI} >> /tmp/web-ui.log

    echo ${BASHPID} > ${RUNFILE}
}

startbrowser
startwebui
refreshloop
