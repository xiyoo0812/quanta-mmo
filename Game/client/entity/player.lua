--Player.lua
local log_warn      = logger.warn

local Player = class()

local prop = property(Player)
prop:reader("id")           --id
prop:reader("user_id")      --user_id
prop:reader("open_id")      --open_id

function Player:__init(open_id)
    self.open_id = open_id
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

return Player
