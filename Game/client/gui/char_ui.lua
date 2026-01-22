--char_ui.lua
local sformat       = string.format

local event_mgr     = quanta.get("event_mgr")
local my_account    = quanta.get("my_account")

local Window = import("gui/Window.lua")
local CharUI = class(Window)

function CharUI:__init()
    self:load_layout("login", "char_ui")
end

function CharUI:init_event()
    self:register_click("close", "back_main")
    self:register_click("random", "rand_name")
    self:register_click("enter", "enter_game")
    self:register_click("create", "create_player")
    self:register_click("delete", "delete_player")
    self:register_click("switch", "switch_create")
    self:register_controler_changed("gender", "gender_changed")
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
    event_mgr:add_trigger(self, "on_login_player_callback")
end

function CharUI:on_close()
    event_mgr:remove_trigger(self, "on_login_player_callback")
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
function CharUI:create_player()
    local name = self:get_child_text("cname")
    local gender = self:get_controller_status("gender")
    local player = my_account:create_player(name, gender, { model = gender })
    if player then
        my_account:choose_player(player.player_id)
    end
end

function CharUI:delete_player()
    local index = self:get_controller_status("selected")
    local player = my_account:get_player(index + 1)
    if player then
        if my_account:delete_player(player) then
            self:init_component()
        end
    end
end

function CharUI:rand_name()
    local ok, name = my_account:random_name()
    if ok then
        self:set_child_text("cname", name)
    end
end

function CharUI:enter_game()
    local index = self:get_controller_status("selected")
    local player = my_account:get_player(index + 1)
    if player then
        my_account:choose_player(player.player_id)
    end
end

function CharUI:on_login_player_callback(ok)
    if ok then
        self:open_gui("loading_ui", true)
    else
        self:back_main()
    end
end

function CharUI:back_main()
    my_account:close()
    self:open_gui("login_ui")
end

function CharUI:switch_create()
    self:set_child_text("cname", "")
    self:set_controller_status("status",  1)
end

function CharUI:gender_changed(context)
    self:set_controller_status("gender", context.sender.selectedIndex, "avatar0")
end

return CharUI
