--xlua.lua
import("kernel.lua")

quanta.startup(function()
    import("entity/player.lua")
    import("core/window_mgr.lua")
    quanta.window_mgr:open_gui("login_ui")
end)
