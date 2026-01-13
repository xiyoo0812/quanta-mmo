--account.lua
local log_err           = logger.err
local log_info          = logger.info
local log_debug         = logger.debug
local qfailed           = quanta.failed
local guid_encode       = codec.guid_encode

local event_mgr         = quanta.get("event_mgr")
local protobuf_mgr      = quanta.get("protobuf_mgr")

local PLAT_PASSWORD     = protobuf_mgr:enum("platform_type", "PLATFORM_PASSWORD")

local TcpClient         = import("network/tcp_client.lua")

local Account = class()
local prop = property(Account)
prop:reader("client", nil)
prop:reader("open_id", nil)
prop:reader("user_id", nil)
prop:reader("lobby_id", nil)
prop:reader("password", nil)
prop:reader("device_id", nil)
prop:reader("player_id", nil)
prop:reader("verify_code", nil)
prop:reader("gate_port", nil)
prop:reader("gate_ip", nil)
prop:reader("players", {})

function Account:__init()
    event_mgr:add_trigger(self, "on_tcp_connected")
    event_mgr:add_trigger(self, "on_gate_connected")
end

function Account:has_player()
    if next(self.players) then
        return true
    end
    return false
end

function Account:on_tcp_connected()
    log_info("[Account][on_tcp_connected] connect login server success")
    self:login_account()
end

function Account:connect(open_id, password)
    self.open_id = open_id
    self.password = password
    local ip, port = environ.addr("QUANTA_LOGIN_ADDR")
    log_info("[Account][login_user] {} login {}:{}", self.open_id, ip, port)
    self.client = TcpClient(ip, port)
    self.client:start()
end


function Account:login_account()
    local device_id = guid_encode()
    local data = { openid = self.open_id, session = self.password, platform = PLAT_PASSWORD, device_id = device_id }
    local ok, res = self.client:call("NID_LOGIN_ACCOUNT_LOGIN_REQ", data)
    log_debug("[Account][login_account] return: {}", res)
    if qfailed(res.error_code, ok) then
        log_err("[Account][login_account] login account failed: {}", res)
        self.client:close()
        return
    end
    self.device_id = device_id
    self.user_id = res.user_id
    self.players = res.players
    event_mgr:notify_trigger("on_login_account_success")
    log_info("[Account][login_account] login account success!")
end

function Account:random_name()
    local ok, res = self.client:call("NID_LOGIN_RANDOM_NAME_REQ", {})
     if qfailed(res.error_code, ok) then
        log_err("[Account][random_name] random failed: {}", res)
        return false
    end
    log_info("[Account][random_name] name : {}", res.name)
    return ok, res.name
end

function Account:create_player(name, gender, facade)
    local data = { user_id = self.user_id, name = name, gender = gender, facade = facade }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_CREATE_REQ", data)
    log_debug("[Account][create_player] return: {}", res)
    if qfailed(res.error_code, ok) then
        log_err("[Account][create_player] create player failed: {}", res)
        return
    end
    local player = res.player
    self.players[player.player_id] = player
    log_info("[Account][create_player] name : {}", player)
end

function Account:choose_player(player_id)
    local data = { user_id = self.user_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_CHOOSE_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][choose_player] create player failed: {}", res)
        return
    end
    self.gate_ip = res.gate_ip
    self.lobby_id = res.lobby_id
    self.gate_port = res.gate_port
    self.player_id = res.player_id
    self.verify_code = res.verify_code
    log_info("[Account][choose_player] name : {}", res)
end

function Account:delete_player(player_id)
    local data = { user_id = self.user_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_DELETE_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][delete_player] delete player failed: {}", res)
        return
    end
    self.players[player_id] = nil
    event_mgr:notify_trigger("on_delete_player_success")
    log_info("[Account][delete_player] delete player: {} success!", player_id)
end

function Account:login_player(player_id)
    local data = { open_id = self.open_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_LOGIN_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][login_player] delete player failed: {}", res)
        return
    end
    event_mgr:notify_trigger("on_login_player_success")
    log_info("[Account][login_player] login player: {} success!", player_id)
end

function Account:logout_player(player_id)
    local data = { open_id = self.open_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_LOGIN_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][logout_player] delete player failed: {}", res)
        return
    end
    event_mgr:notify_trigger("on_logout_player_success")
    log_info("[Account][logout_player] logout player: {} success!", player_id)
end

quanta.my_account = Account()

return Account
