--login_ui.lua
local log_err       = logger.err

local event_mgr     = quanta.get("event_mgr")
local my_account    = quanta.get("my_account")

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
        my_account:connect(open_id, password)
    end)
end

function LoginUI:init_component()
    event_mgr:add_trigger(self, "on_login_account_success")
end

function LoginUI:on_close()
    event_mgr:remove_trigger(self, "on_login_account_success")
end

function LoginUI:on_login_account_success()
    self:open_gui("char_ui", true)
end

return LoginUI
