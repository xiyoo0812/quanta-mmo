--account.lua
local log_err           = logger.err
local log_info          = logger.info
local log_debug         = logger.debug
local terase            = table.erase
local tinsert           = table.insert
local qfailed           = quanta.failed
local guid_encode       = codec.guid_encode

local event_mgr         = quanta.get("event_mgr")
local protobuf_mgr      = quanta.get("protobuf_mgr")

local PLAT_PASSWORD     = protobuf_mgr:enum("platform_type", "PLATFORM_PASSWORD")

local Player            = import("entity/player.lua")
local TcpClient         = import("network/tcp_client.lua")

local Account = class()
local prop = property(Account)
prop:reader("client", nil)
prop:reader("open_id", nil)
prop:reader("user_id", nil)
prop:reader("password", nil)
prop:reader("device_id", nil)
prop:reader("cur_player", nil)
prop:reader("players", {})

function Account:__init()
    event_mgr:add_trigger(self, "on_tcp_connected")
end

function Account:close()
    self.client:close()
    self.client = nil
    self.open_id = nil
    self.user_id = nil
    self.password = nil
    self.device_id = nil
    self.players = {}
    if self.cur_player then
        self.cur_player:close()
        self.cur_player = nil
    end
end

function Account:has_player()
    if next(self.players) then
        return true
    end
    return false
end

function Account:get_player(index)
    return self.players[index]
end

function Account:on_tcp_connected()
    log_info("[Account][on_tcp_connected] connect login server success")
    self:login_account()
end

function Account:connect(open_id, password)
    self.open_id = open_id
    self.password = password
    local ip, port = environ.addr("QUANTA_LOGIN_ADDR")
    log_info("[Account][connect] {} connect {}:{}", self.open_id, ip, port)
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
    if res.players then
        self.players = res.players
    end
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
    tinsert(self.players, player)
    log_info("[Account][create_player] name : {}", player)
    return player
end

function Account:choose_player(player_id)
    local data = { user_id = self.user_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_CHOOSE_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][choose_player] create player failed: {}", res)
        return
    end
    log_info("[Account][choose_player] res : {}", res)
    local player = Player(self.open_id, self.user_id, res.player_id)
    player:connect(res.gate_ip, res.gate_port, player.lobby_id, player.verify_code)
    self.cur_player = player
end

function Account:delete_player(player)
    local player_id = player.player_id
    local data = { user_id = self.user_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_DELETE_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Account][delete_player] delete player failed: {}", res)
        return false
    end
    terase(self.players, player)
    event_mgr:notify_trigger("on_delete_player_success")
    log_info("[Account][delete_player] delete player: {} success!", player_id)
    return true
end

quanta.my_account = Account()

return Account
