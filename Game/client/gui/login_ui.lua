--login_ui.lua

local event_mgr     = quanta.get("event_mgr")

local Window = import("gui/Window.lua")
local LoginUI = class(Window)

function LoginUI:__init()
    self:load_layout("login", "login_ui")
end

function LoginUI:init_event()
    self:register_click("login", self.login_game)
end

function LoginUI:init_component()
    event_mgr:add_trigger(self, "on_login_player_success")
end

function LoginUI:on_close()
    event_mgr:remove_trigger(self, "on_login_player_success")
end

function LoginUI:on_login_player_success()
    self:open_gui("char_ui", true)
end

return LoginUI
