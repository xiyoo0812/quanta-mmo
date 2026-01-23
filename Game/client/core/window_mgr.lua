--window_mgr.lua

local log_err       = logger.err
local sformat       = string.format

local ABMgr         = CS.ABMgr
local Engine        = CS.UnityEngine
local GRoot         = CS.FairyGUI.GRoot
local Stage         = CS.FairyGUI.Stage
local UIPackage     = CS.FairyGUI.UIPackage
local ContentScaler = CS.FairyGUI.UIContentScaler

local UNITY_DRITOR  = environ.status("QUANTA_UNITY_DRITOR")

local WindowMgr = singleton()
local prop = property(WindowMgr)
prop:reader("guis", {})
prop:reader("packages", {})

function WindowMgr:__init()
    self:add_package("widget")
    local tex = Engine.Resources.Load("Mouse/UI_Common_Img_Mouse_1.png")
    Stage.inst:RegisterCursor("text-link", tex, Engine.Vector2(0,0))

    Engine.Screen.SetResolution(1920, 1080, false)
    GRoot.inst:SetContentScaleFactor(1920, 1080, ContentScaler.ScreenMatchMode.MatchWidth)
end

function WindowMgr:__release()
    for _, win in pairs(self.guis) do
        win:destory()
    end
    UIPackage.RemoveAllPackages()
    self.packages = {}
    self.guis = {}
end

function WindowMgr:add_package(name)
    if self.packages[name] then
        return
    end
    if UNITY_DRITOR then
        local pkg = UIPackage.AddPackage("FairyGUI/" .. name)
        if not pkg then
            log_err("[WindowMgr][add_package] add package: {} failed!", name)
            return
        end
        self.packages[name] = pkg
    else
        local ab = ABMgr.LoadAB(name)
        if not ab then
            log_err("[WindowMgr][add_package] load ab: {} failed!", name)
            return
        end
        local pkg = UIPackage.AddPackage(ab)
        if not pkg then
            log_err("[WindowMgr][add_package] add package: {} failed!", name)
            return
        end
        self.packages[name] = pkg
    end
end

function WindowMgr:remove_package(name)
    local pkg = self.packages[name]
    if pkg then
        UIPackage.RemovePackage(name)
    end
end

function WindowMgr:load_layout(package, layout)
    self:add_package(package)
    return UIPackage.CreateObject(package, layout)
end

function WindowMgr:create_gui(name, parent)
    parent = parent or GRoot.inst
    local gui = self.guis[name]
    if not gui then
        local window = import(sformat("gui/%s.lua", name))
        gui = window(parent, name)
        self.guis[name] = gui
    end
    return gui
end

function WindowMgr:open_gui(name)
    local gui = self:create_gui(name)
    if gui then
        gui:open()
        return gui
    end
end

quanta.window_mgr = WindowMgr()

return WindowMgr

