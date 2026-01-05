--role.lua
local log_warn      = logger.warn

local Role = class()

local prop = property(Role)
prop:reader("id")                       --id

function Role:__init(id)
    self.id = id
end

-- 初始化
function Role:setup(conf)
    if not self:load(conf) then
        log_warn("[Role][setup] Role {} load faild!", self.id)
        return false
    end
    local setup_ok = self:collect("_setup")
    if not setup_ok then
        log_warn("[Role][setup] Role {} setup faild!", self.id)
        return setup_ok
    end
    return setup_ok
end

--load
function Role:load(conf)
    return true
end

--check
function Role:check()
    return true
end

--update
function Role:update(now)
    if self:check(now) then
        self:invoke("_update", now)
    end
end

--destory
function Role:destory()
    self:unload()
end

return Role
