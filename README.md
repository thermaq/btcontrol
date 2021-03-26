Raspberry pi as bluetooth speaker tutorial or something.

# btcontrol
Python script for automatic bluetoothctl management in my car audio project

I use a raspberry pi with a touchscreen from aliexpress, a cheap DAC (UGR474BLK) and a bluetooth dongle (internal rpi 3b bt sucks) as a headunit in my miata.

This script gets started up after bluetooth service and commands bluetoothctl to automatically make the pi pairable, discoverable and accept pairings, trust them and accept connections.

# other parts of the setup

## pulseaudio
I use pulseaudio with LADSPA for equalisation which is really needed in a car that has little to no deadning. Or roof for that matter. I found pulseaudio-equalizer-ladspa to be the most reliable and I was able to start it up from system.pa during bootup

I also had to make a quick and dirty pulseaudio module to restart bluetooth and start the script. Ladspa increased pulseaudio startup time quite a bit and made bluetooth communication with it unreliable during boot up. I also encountered that phone trying to pair with bluetooth that is still trying to talk to pulse renders the whole pairing process moot.

I'll include a script to compile the module later. Also the most reliable version was 13.99, so that's the other reason I compile pulse from scratch.

## awesome

I wanted as fast boot as possible (which is quite a feat when using rpi of any sort). I chose awesome wm and lxdm for ui because it's fast, reliable and I could make big buttons and bluetooth controller in wm config itself.

## filesystem

Car audio unfortunatelly is subjected to vibration, weather, power outages and other random stuff.
That's why I made as much stuff read only as possible. I use rc.local to create tmpfses where needed and copy stuff there, like user's home directory. It needs to be writable, but I don't want it to get corrupted next time I stall my engine, so I mount /home/pi as tmpfs and copy /home/pi_template there. Equaliser settings are stored here, so after I change something I must click "commit" from awesomewm menu - it remounts the system rw and copies /home/pi into /home/pi_template.
