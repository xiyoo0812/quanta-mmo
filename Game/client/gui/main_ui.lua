--main_ui.lua

local Window = import("gui/Window.lua")

local MainUI = class(Window)

function MainUI:__init()
    self:load_layout("main", "main_ui")
end

function MainUI:init_event()
end

function MainUI:init_component()
end

function MainUI:on_close()
end

return MainUI
