local wibox           = require("wibox")
local gdebug          = require("gears.debug")
local io              = { lines  = io.lines }
local math            = { floor  = math.floor }
local string          = { format = string.format,
                          gmatch = string.gmatch,
                          len    = string.len }

local setmetatable    = setmetatable



local function worker(args)
    local btbutton = wibox.widget {
        widget = wibox.widget.imagebox
    }
    local args     = args or {}
    local timeout  = args.timeout or 1
    local settings = args.settings or function() end
    btbutton.folder = "none"
    btbutton.state = -1
    function btbutton:update(new_state)
        if self.state == new_state then
            return
        end
        self.state = new_state
        if new_state == -1 then
            self:set_image(self.folder .. "off.png")
        elseif new_state == 0 then
            self:set_image(self.folder .. "middle.png")
        elseif new_state == 1 then
            self:set_image(self.folder .. "on.png")
        else
            self:set_image(self.folder .. "blank.png")
        end
    end
    btbutton.widget = wibox.widget.imagebox
    btbutton:connect_signal("button::press", function(c) c:set_bg("#000000") end)
    btbutton:connect_signal("button::release", function(c) c:set_bg('#00000066') end)

    return btbutton
end

return worker
