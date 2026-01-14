--char_ui.lua
local log_err       = logger.err
local sformat       = string.format

local my_account    = quanta.get("my_account")

local Window = import("gui/Window.lua")
local CharUI = class(Window)

function CharUI:__init()
    self:load_layout("login", "char_ui")
end

function CharUI:init_event()
    self:register_click("close", function()
        my_account:exit()
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
        local gender = self:get_controller_status("gender")
        if my_account:create_player(name, gender, { model = gender }) then
            self:set_controller_status("status",  0)
            self:show_players()
        end
    end)
    self:register_click("delete", function()
        local index = self:get_controller_status("selected")
        local player = my_account:get_player(index + 1)
        if player then
            if my_account:delete_player(player) then
                self:init_component()
            end
        end
    end)
    self:register_click("switch", function()
        self:set_child_text("cname", "")
        self:set_controller_status("status",  1)
    end)
    self:register_click("enter", function()
        log_err("进入游戏")
    end)
end

function CharUI:init_component()
    if my_account:has_player() then
        self:set_controller_status("status",  0)
        self:show_players()
    else
        self:set_child_text("cname", "")
        self:set_controller_status("status",  1)
        self:set_controller_status("gender",  0, "avatar0")
    end
end

function CharUI:show_players()
    local players = my_account:get_players()
    self:show_child("switch", #players < 3)
    for index = 1, 3 do
        local player = players[index]
        local child_name = sformat("avatar%d", index)
        self:show_child(child_name, player ~= nil)
        if player then
            self:set_child_text(child_name, player.name)
            self:set_controller_status("gender",  player.gender, child_name)
        end
    end
end

return CharUI
