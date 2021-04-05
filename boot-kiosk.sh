#!/bin/bash

# Be sure to set the path to your '.kiosk.cfg' file, by default it's looking to the users home directory
CFG=$HOME/.kiosk.cfg

# Here we'll load the contents of the '.kiosk.cfg' file, allows us to keep variables consistant and reuable
source ${CFG}

# Get the first URL from our URLFILE and open it initially
URL=`cat ${URLFILE} | grep -v "#" | head -1 | awk -F, '{print $3}'`

/usr/bin/chromium-browser ${URL} --kiosk --noerrdialogs --disable-session-crashed-bubble --disable-infobars &

while true; #create an infinite loop to refresh
do
    # This creates a loop to initiate refreshes of the browser window. If in 'kiosk.cfg' you have REFRESH set to NONE
    # then no refresh is performed, however this will still loop looking at the config file incase you update it with
    # a value, then the refresh will be performed on that time schedule.

    REFRESH=`grep -i "^REFRESH=" ${CFG} | sed 's/^REFRESH=//' | tr '[:upper:]' '[:lower:]'`

    if [ "${REFRESH}" = "none" ]; then
        sleep 20
    else
        sleep ${REFRESH}
        # This sends the CTRL+F5 keystroke to the foreground app, hopefully it's your browser.
        xdotool key ctrl+F5 & #you need to have xdotools installed
    fi
done