# Raspberry-pi-kiosk-config

How I configure a Raspberry Pi 4 in kiosk mode

For my screen I'm using the [EVICIV 7 Inch Touchscreen](https://www.amazon.co.uk/gp/product/B07Q2LBWYK/ref=ppx_yo_dt_b_asin_title_o08_s00). This screen runs at 1024 x 600, this is not a standard size. Making this work is simple but google provides a lot of conflicting information.

To get it working, edit `/boot/config.txt` and add these lines at the end, save and reboot.

```
hdmi_force_hotplug=1
hdmi_cvt=1024 600 60 3
hdmi_group=2
hdmi_mode=88
```

# Configure Pixel Desktop

## Pixel Desktop Autostart

The [autostart](autostart) script should be placed into the directory

    mkdir -p ~/.config/lxsession/LXDE-pi/
    cp autostart ~/.config/lxsession/LXDE-pi/autostart

## Starting Chromium in Kiosk mode

The [boot-kiosk.sh](boot-kiosk.sh) script is called from the [autostart](autostart) script, it simply launches the chromium browser in `kiosk` mode to the URL provided in the script.

# Controlling the Kiosk display

The [kioskctl](kioskctl) script does a number of functions through a simple `case` statement. This script can be calld via cron or another script that prehaps is connected to motion sensor to power on the HDMI display or power it off when not require.

This script also allows you to open preset URL's or just give it any URL you'd like to have opened in the browser.

----
This is still a work in progress as I develop it for my needs. Feel free to use the scripts and such. 