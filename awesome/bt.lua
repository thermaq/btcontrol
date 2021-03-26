local wibox           = require("wibox")
local gears           = require("gears")
local gdebug          = require("gears.debug")
local BtButton        = require("btbutton")
local awful	      = require("awful")
local io              = { lines  = io.lines }
local math            = { floor  = math.floor }
local string          = { format = string.format,
                          gmatch = string.gmatch,
                          len    = string.len }

local capi = { timer = timer }
local timer = gears.timer {
    timeout   = 1
}

local setmetatable    = setmetatable

local bt = {
	layout=wibox.layout.fixed.vertical() 
}

local function worker(args)
    local args     = args or {}
    local timeout  = args.timeout or 1
    local settings = args.settings or function() end

    local pa = BtButton {}
    pa.folder = "/home/pi/.config/awesome/bticos/pa/"
    local power = BtButton {}
    power.folder = "/home/pi/.config/awesome/bticos/power/"
    local discoverable = BtButton{}
    discoverable.folder = "/home/pi/.config/awesome/bticos/discoverable/"
    local pairable = BtButton{}
    pairable.folder = "/home/pi/.config/awesome/bticos/pairable/"
    local sink = BtButton{}
    sink.folder = "/home/pi/.config/awesome/bticos/sink/"
    local headset = BtButton {}
    headset.folder = "/home/pi/.config/awesome/bticos/headset/"

    pa:connect_signal("button::press", function(c, _, _, button)
        c:set_bg("#000000")
        awful.spawn.easy_async_with_shell('sudo systemctl restart pulseaudio')
    end)

    power:connect_signal("button::press", function(c, _, _, button)
        c:set_bg("#000000")
        awful.spawn.easy_async_with_shell('sudo systemctl restart bluetooth')
    end)

    discoverable:connect_signal("button::press", function(c, _, _, button)
        c:set_bg("#000000")
        if c.state == -1 then
            awful.spawn.easy_async_with_shell('bluetoothctl discoverable on')
        else
            awful.spawn.easy_async_with_shell('bluetoothctl discoverable off')
        end
    end)

    pairable:connect_signal("button::press", function(c, _, _, button)
        c:set_bg("#000000")
        if c.state == -1 then
            awful.spawn.easy_async_with_shell('bluetoothctl pairable on')
        else
            awful.spawn.easy_async_with_shell('bluetoothctl pairable off')
        end
    end)
    local bg = {
	layout=wibox.layout.fixed.vertical,
        pa,
        power,
        discoverable,
        pairable,
        sink,
        headset
    }

    function bt.update()
        awful.spawn.easy_async_with_shell('timeout 0.5 bluetoothctl show', function(stdout, stderr, reason, exit_code)
            power_state = 0
            discoverable_state = -1
            pairable_state = -1
            sink_state = -1
            headset_state = -1

            if exit_code == 124 then
                power_state = -1
            else
                if stdout:find("Powered: yes\n") then
                    power_state = 1
                end
                if stdout:find("Discoverable: yes\n") then
                    discoverable_state = 1
                end
                if stdout:find("Pairable: yes\n") then
                    pairable_state = 1
                end
                if stdout:find("UUID: Audio Sink") then
                    sink_state = 1
                end
                if stdout:find("UUID: Headset") then
                    headset_state = 1
                end
            end

            power:update(power_state)
            discoverable:update(discoverable_state)
            pairable:update(pairable_state)
            sink:update(sink_state)
            headset:update(headset_state)
        end)

        awful.spawn.easy_async_with_shell('pactl --server="unix:/usr/local/var/run/pulse/native" info', function(stdout, stderr, reason, exit_code)
            if stdout:find("Connection failure: Connection") then
                pa:update(-1)
            elseif stdout:find("ladspa") then
                pa:update(1)
            else
                pa:update(0)
            end
        end)
    end

    timer:connect_signal("timeout", bt.update)
    timer:start()


    return bg
end

return setmetatable(bt, { __call = function(_, ...) return worker(...) end })
