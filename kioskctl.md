The options are pretty self-explanatory. Options are `not` case sensitive.

1. `Off` & `On` simply control the HDMI screen using the `vcgencmd display_power X` command, `X` represents a `0` or `1` for `off` and `on` respectively.

2. The `Refresh` option used without any number will simply force a refresh of the displayed page in the browser.

3. Using `Refresh ###` where `###` is the number of seconds between automated refreshes (`0` - no refreshes), this will also update your `.kiosk.cfg` file with the new refresh number. This also means that the new number will persist between reboots and restarts of the Windowed environment.

4. The URLS are also not case sensitive. When adding new ones observe the simple CSV format of the file. 

```
$ ./kioskctl --help 

There are 2 commands plus a list of short names you can use to control this script

    Command              Description                              
    ---------------      -----------------------------------      
    On                   This will turn ON the screen             
    Off                  This will turn OFF the screen            
                         Screen power override can be made by creating a file called `.powermode` in your home directory. 
                         If the first line is just `stayon` or `stayoff` then the above cmds will respect this file. 
                         If the file `.powermode` doesn't exist then off / on commands work as expected. 

    Refresh              Refreshes the browser                    
    Refresh ###          Provide a number to change refresh time period (Current refresh rate: 120) 
    Help                 Prints this help screen                  


    Short Name           Description                              URL                                      
    ---------------      -----------------------------------      ----------------------------------------------------------------- 
    bbc                  BBC News                                 https://news.bbc.co.uk                   
    cnn                  CNN News                                 https://edition.cnn.com/                 
    weather              Met Weather - London                     https://www.metoffice.gov.uk/weather/forecast/gcpvj0v07 
    natgrid              UK National Power Grid                   https://grid.iamkate.com/                
    rcg                  Random Comic Generator                   https://explosm.net/rcg                  
```

[back to README.md](https://github.com/M1XZG/Raspberry-pi-kiosk-config)
