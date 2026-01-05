--Player.lua
local log_warn          = logger.warn

local LoginComponent    = import("component/login_component.lua")

local Player = class(nil, LoginComponent)

local prop = property(Player)
prop:accessor("id", nil)    --id

function Player:__init()
end

-- 初始化
function Player:setup(conf)
    if not self:load(conf) then
        log_warn("[Player][setup] {} load faild!", self.id)
        return false
    end
    local setup_ok = self:collect("_setup")
    if not setup_ok then
        log_warn("[Player][setup] {} setup faild!", self.id)
        return setup_ok
    end
    return setup_ok
end

--load
function Player:load(conf)
    return true
end

--check
function Player:check()
    return true
end

--update
function Player:update(now)
    if self:check(now) then
        self:invoke("_update", now)
    end
end

--destory
function Player:destory()
    self:unload()
end

quanta.my_player = Player()

return Player
