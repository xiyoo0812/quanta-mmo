--loading_ui.lua

local SceneManager  = CS.UnityEngine.SceneManagement.SceneManager

local update_mgr    = quanta.get("update_mgr")

local Window = import("gui/Window.lua")
local LoadingUI = class(Window)

function LoadingUI:__init()
    self:load_layout("login", "loading_ui")
end

function LoadingUI:init_event()
    self.progress = self:get_child("progress")
end

function LoadingUI:init_component()
    self:set_progress(0)
end

function LoadingUI:on_close()
end

function LoadingUI:set_progress(val)
    self.progress.value = val
end

function LoadingUI:load_main()
    self.curcent = 0
    self.async_operation = SceneManager.LoadSceneAsync("Main")
    update_mgr:attach_frame(self)
end

function LoadingUI:on_frame()
    self.curcent = self.curcent + math.random(10, 20)
    local real_progress = self.async_operation.progress * 100
    local progress = math.min(self.curcent, real_progress)
    self:set_progress(progress)
    if progress >= 100 then
        self:openGUI("main_ui", true)
        update_mgr:detach_frame(self)
    end
end
return LoadingUI
