In order to get the LG29 Ultrawide display working with an `AMD HD 5850` X.Org must be used.
The following Modeline works "fine"
```
Modeline “2560x1080x53.92” 162.500000 2560 2608 2640 2720 1080 1083 1087 1108 +HSync -VSync
```

https://forum.manjaro.org/t/it-is-possible-to-use-2560x1080-resolution-on-linux-using-ati-radeon/21315/13

Assuming that it is connected to the `HDMI-1` port:
```bash
xrandr --newmode “2560x1080x53.92” 162.500000 2560 2608 2640 2720 1080 1083 1087 1108 +HSync -VSync
xrandr --addmode HDMI-0 “2560x1080x53.92”
xrandr --verbose --output HDMI-0 --mode “2560x1080x53.92” 
```
This will create the mode and activate.