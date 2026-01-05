--login_ui.lua
local log_err       = logger.err

local my_player     = quanta.get("my_player")

local Window = import("gui/Window.lua")
local LoginUI = class(Window)

function LoginUI:__init()
    self:load_layout("login", "login_ui")
end

function LoginUI:init_event()
    self:register_click("login", function()
        local open_id = self:get_child_text("username")
        local password = self:get_child_text("password")
        if not open_id or not password then
            log_err("账号或密码不能为空")
            return
        end
        my_player:login_user(open_id, password)
    end)
end

function LoginUI:init_component()
end

function LoginUI:on_close()
end

return LoginUI
