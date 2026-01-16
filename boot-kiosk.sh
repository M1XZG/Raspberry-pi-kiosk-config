#!/bin/bash

# Configuration file path - required for this script to function
CFG="$HOME/.kiosk.cfg"

# Validate that config file exists before attempting to source it
if [[ ! -f "${CFG}" ]]; then
    echo "ERROR: Configuration file not found at ${CFG}" >&2
    echo "Please copy .kiosk.cfg to your home directory" >&2
    exit 1
fi

# Source the configuration file to load all variables
source "${CFG}"

# Verify required variables are set after sourcing config
if [[ -z "${RUNFILE}" ]] || [[ -z "${URLFILE}" ]] || [[ -z "${BROWSER}" ]]; then
    echo "ERROR: Required configuration variables not set in ${CFG}" >&2
    exit 1
fi

# Clean up old run file if it exists and create a new one
# This file tracks which URL is displaying and the refresh schedule
if [[ -f "${RUNFILE}" ]]; then
    rm -f "${RUNFILE}"
fi

echo "${BASHPID}" > "${RUNFILE}"

# Infinite loop that refreshes the browser based on the REFRESH config setting
# This function re-reads the config file on each iteration, allowing runtime changes without restart
refresh_loop() {
    while :; do
        # Re-read REFRESH setting from config file each iteration
        # This allows changing refresh interval without restarting the script
        REFRESH=$(grep -i "^REFRESH=" "${CFG}" | sed 's/^REFRESH=//')

        # If REFRESH is 0 or NONE, just wait without actually refreshing
        if [[ "${REFRESH}" = "0" ]] || [[ "${REFRESH}" = "NONE" ]]; then
            sleep 20
        else
            sleep "${REFRESH}"
            # Send Ctrl+F5 to refresh the browser window
            xdotool key ctrl+F5 &
        fi
    done
}

# Start the browser with the first URL from the configuration
start_browser() {
    # Validate URLFILE exists
    if [[ ! -f "${URLFILE}" ]]; then
        echo "ERROR: URL file not found at ${URLFILE}" >&2
        exit 1
    fi
    
    # Extract the first non-comment URL from the file (3rd field, comma-separated)
    local URL
    URL=$(grep -v "^#" "${URLFILE}" | head -1 | awk -F, '{print $3}')
    
    if [[ -z "${URL}" ]]; then
        echo "ERROR: No valid URLs found in ${URLFILE}" >&2
        exit 1
    fi
    
    # Start browser with kiosk mode flags
    "${BROWSER}" "${URL}" --kiosk --noerrdialogs --disable-session-crashed-bubble --disable-infobars &
}

# Execute startup sequence
start_browser
refresh_loop
