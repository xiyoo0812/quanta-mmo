--loading_ui.lua

--local SceneManager  = CS.UnityEngine.SceneManagement.SceneManager

local update_mgr    = quanta.get("update_mgr")

local Window = import("gui/Window.lua")
local LoadingUI = class(Window)
local prop = property(LoadingUI)
prop:reader("curcent", 0)
prop:reader("progress", nil)

function LoadingUI:__init()
    self:load_layout("login", "loading_ui")
end

function LoadingUI:init_event()
    self.progress = self:get_child("progress")
end

function LoadingUI:init_component()
    self:load_main()
end

function LoadingUI:on_close()
end

function LoadingUI:set_progress(val)
    self.progress.value = val
    self.curcent = val
end

function LoadingUI:load_main()
    self:set_progress(0)
    update_mgr:attach_frame(self)
    -- self.async_operation = SceneManager.LoadSceneAsync("Main")
end

function LoadingUI:on_frame()
    -- local real_progress = self.async_operation.progress * 100
    -- local progress = math.min(self.curcent, real_progress)
    local progress = self.curcent + math.random(5, 10)
    self:set_progress(progress)
    if progress >= 100 then
        update_mgr:detach_frame(self)
        self:open_gui("main_ui", true)
    end
end
return LoadingUI
