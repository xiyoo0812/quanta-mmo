--login_component.lua
local log_err           = logger.err
local log_info          = logger.info
local log_debug         = logger.debug
local qfailed           = quanta.failed
local guid_encode       = codec.guid_encode

local event_mgr         = quanta.get("event_mgr")
local protobuf_mgr      = quanta.get("protobuf_mgr")

local PLAT_PASSWORD     = protobuf_mgr:enum("platform_type", "PLATFORM_PASSWORD")

local TcpClient         = import("network/tcp_client.lua")

local LoginComponent = mixin()
local prop = property(LoginComponent)
prop:reader("client", nil)
prop:reader("open_id", nil)
prop:reader("user_id", nil)
prop:reader("password", nil)
prop:reader("device_id", nil)
prop:reader("roles", {})

function LoginComponent:__init()
    event_mgr:add_trigger(self, "on_tcp_connected")
    event_mgr:add_trigger(self, "on_gate_connected")
end

function LoginComponent:has_role()
    if next(self.roles) then
        return true
    end
    return false
end

function LoginComponent:on_tcp_connected()
    log_info("[LoginComponent][on_tcp_connected] connect login server success")
    self:login_account()
end

function LoginComponent:on_gate_connected()
end

function LoginComponent:login_user(open_id, password)
    self.open_id = open_id
    self.password = password
    local ip, port = environ.addr("QUANTA_LOGIN_ADDR")
    log_info("[LoginComponent][login_user] {} login {}:{}", self.open_id, ip, port)
    self.client = TcpClient(ip, port)
    self.client:start()
end

function LoginComponent:login_account()
    local device_id = guid_encode()
    local data = { openid = self.open_id, session = self.password, platform = PLAT_PASSWORD, device_id = device_id }
    local ok, res = self.client:call("NID_LOGIN_ACCOUNT_LOGIN_REQ", data)
    log_debug("[LoginComponent][login_account] return: {}", res)
    if qfailed(res.error_code, ok) then
        log_err("[LoginComponent][login_account] login account failed: {}", res)
        self.client:close()
        return
    end
    self.device_id = device_id
    self.user_id = res.user_id
    for _, role in ipairs(res.roles or {}) do
        self.roles[role.role_id] = role
    end
    event_mgr:notify_trigger("on_login_account_success")
    log_info("[LoginComponent][login_account] login account success!")
end

function LoginComponent:random_name()
    local ok, res = self.client:call("NID_LOGIN_RANDOM_NAME_REQ", {})
     if qfailed(res.error_code, ok) then
        log_err("[LoginComponent][random_name] random name failed!")
        return false
    end
    log_info("[LoginComponent][random_name] name : {}", res.name)
    return ok, res.name
end

return LoginComponent
