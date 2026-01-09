--char_ui.lua
local log_err       = logger.err

local my_player     = quanta.get("my_player")

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
        local ok, name = my_player:random_name()
        if ok then
            self:set_child_text("cname", name)
        end
    end)
    self:register_click("create", function()
        log_err("创建角色")
    end)
    self:register_click("enter", function()
        log_err("进入游戏")
    end)
end

function CharUI:init_component()
    self:set_controller_status("status",  my_player:has_player() and 0 or 1)
end

return CharUI
