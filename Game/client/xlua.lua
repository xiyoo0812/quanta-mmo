--xlua.lua
import("kernel.lua")

quanta.startup(function()
    import("client.lua")
    quanta.window_mgr:open_gui("login_ui")
end)
