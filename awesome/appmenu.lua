local appmenu = {}

appmenu.Accessories = {
    { 'Character Map', 'gucharmap' },
    { 'ClipIt', 'clipit', '/usr/share/icons/hicolor/scalable/apps/clipit-trayicon-offline.svg' },
    { 'Disks', 'gnome-disks', '/usr/share/icons/hicolor/24x24/apps/gnome-disks.png' },
    { 'File Manager PCManFM', 'pcmanfm' },
    { 'Galculator', 'galculator', '/usr/share/icons/hicolor/scalable/apps/galculator.svg' },
    { 'Image Viewer', 'gpicview', '/usr/share/icons/hicolor/48x48/apps/gpicview.png' },
    { 'Leafpad', 'leafpad', '/usr/share/icons/hicolor/24x24/apps/leafpad.png' },
    { 'Onboard', 'onboard', '/usr/share/icons/hicolor/28x28/apps/onboard.png' },
    { 'Screenshot', 'gnome-screenshot --interactive' },
    { 'Vim', 'xterm -e vim', '/usr/share/icons/hicolor/scalable/apps/gvim.svg' },
    { 'Xarchiver', 'xarchiver', '/usr/share/icons/hicolor/24x24/apps/xarchiver.png' },
}

appmenu.Graphics = {
    { 'Document Viewer', 'evince', '/usr/share/icons/hicolor/24x24/apps/org.gnome.Evince.png' },
    { 'Image Viewer', 'gpicview', '/usr/share/icons/hicolor/48x48/apps/gpicview.png' },
}

appmenu.Internet = {
    { 'Deluge', 'deluge-gtk', '/usr/share/icons/hicolor/24x24/apps/deluge.png' },
    { 'Firefox ESR', '/usr/lib/firefox-esr/firefox-esr', '/usr/share/icons/hicolor/128x128/apps/firefox-esr.png' },
    { 'Wicd Network Manager', 'wicd-gtk --no-tray', '/usr/share/icons/hicolor/24x24/apps/wicd-gtk.png' },
}

appmenu.Office = {
    { 'Document Viewer', 'evince', '/usr/share/icons/hicolor/24x24/apps/org.gnome.Evince.png' },
}

appmenu.MultiMedia = {
    { 'Calf Plugin Pack for JACK', 'calfjackhost', '/usr/share/icons/hicolor/24x24/apps/calf.png' },
    { 'LXMusic simple music player', 'lxmusic' },
    { 'PulseAudio Volume Control', 'sudo pavucontrol' },
    { 'SMPlayer', 'smplayer', '/usr/share/icons/hicolor/128x128/apps/smplayer.png' },
    { 'mpv Media Player', 'mpv --player-operation-mode=pseudo-gui --', '/usr/share/icons/hicolor/64x64/apps/mpv.png' },
}

appmenu.Settings = {
    { 'About Myself', 'userinfo' },
    { 'Customize Look and Feel', 'lxappearance' },
    { 'Desktop Preferences', 'pcmanfm --desktop-pref' },
    { 'Keyboard and Mouse', 'lxinput' },
    { 'Monitor Settings', 'lxrandr' },
    { 'Onboard Settings', 'onboard-settings', '/usr/share/icons/hicolor/28x28/apps/onboard.png' },
    { 'Openbox Configuration Manager', 'obconf' },
    { 'Password', 'userpasswd' },
    { 'Raspberry Pi Configuration', 'env SUDO_ASKPASS=/usr/lib/rc-gui/pwdrcg.sh sudo -AE rc_gui', '/usr/share/icons/hicolor/32x32/apps/rpi.png' },
    { 'Screensaver', 'xscreensaver-demo' },
    { 'Setup Hot Keys', 'lxhotkey --gui=gtk' },
    { 'Time and Date', 'time-admin', '/usr/share/icons/hicolor/24x24/apps/time-admin.png' },
    { 'Users and Groups', 'users-admin' },
}

appmenu.System = {
    { 'Disk Management', 'usermount' },
    { 'File Manager PCManFM', 'pcmanfm' },
    { 'Htop', 'xterm -e htop' },
    { 'LXTerminal', 'lxterminal', '/usr/share/icons/hicolor/128x128/apps/lxterminal.png' },
    { 'Task Manager', 'lxtask' },
    { 'Time and Date', 'time-admin', '/usr/share/icons/hicolor/24x24/apps/time-admin.png' },
    { 'Users and Groups', 'users-admin' },
}

appmenu.Appmenu = {
    { 'Accessories', appmenu.Accessories },
    { 'Graphics', appmenu.Graphics },
    { 'Internet', appmenu.Internet },
    { 'Office', appmenu.Office },
    { 'MultiMedia', appmenu.MultiMedia },
    { 'Settings', appmenu.Settings },
    { 'System', appmenu.System },
}

return appmenu