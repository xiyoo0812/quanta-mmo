--login_ui.lua

local Window = import("gui/Window.lua")

local LoginUI = class(Window)

function LoginUI:__init()
    self:load_layout("login", "login_ui")
end

function LoginUI:init_event()
end

function LoginUI:init_component()
end

function LoginUI:on_close()
end

return LoginUI
