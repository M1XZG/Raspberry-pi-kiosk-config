#!/bin/sh

# This URL is really just to get chromium started. The URL can be changed using the kioskctl command once
# things are started.

URL=https://MyDashboardURL.local/freeboard

/usr/bin/chromium-browser ${URL} --kiosk --noerrdialogs --disable-session-crashed-bubble --disable-infobars