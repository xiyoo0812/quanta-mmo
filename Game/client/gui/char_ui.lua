--char_ui.lua
local log_err       = logger.err

local my_account     = quanta.get("my_account")

local Window = import("gui/Window.lua")
local CharUI = class(Window)

function CharUI:__init()
    self:load_layout("login", "char_ui")
end

function CharUI:init_event()
    self:register_click("close", function()
        self:open_gui("login_ui")
    end)
    self:register_click("random", function()
        local ok, name = my_account:random_name()
        if ok then
            self:set_child_text("cname", name)
        end
    end)
    self:register_controler_changed("gender", function(context)
        self:set_controller_status("gender", context.sender.selectedIndex, "avatar0")
    end)
    self:register_click("create", function()
        local name = self:get_child_text("cname")
        local gender = self:set_controller_status("gender")
        my_account:create_player(name, gender)
    end)
    self:register_click("enter", function()
        log_err("进入游戏")
    end)
end

function CharUI:init_component()
    if my_account:has_player() then
        self:set_controller_status("status",  0)
    else
        self:set_controller_status("status",  1)
        self:set_controller_status("gender",  0, "avatar0")
    end
end

return CharUI
