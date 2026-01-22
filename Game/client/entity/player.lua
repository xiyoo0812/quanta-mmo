--player.lua
local log_err       = logger.err
local log_info      = logger.info
local qfailed       = quanta.failed

local event_mgr     = quanta.get("event_mgr")

local GateClient    = import("network/gate_client.lua")

local Player = class()
local prop = property(Player)
prop:reader("client", nil)
prop:reader("open_id", nil)
prop:reader("user_id", nil)
prop:reader("player_id", nil)

function Player:__init(open_id, user_id, player_id)
    self.open_id = open_id
    self.user_id = user_id
    self.player_id = player_id
    event_mgr:add_trigger(self, "on_gate_connected")
end

function Player:close()
    self.client:close()
    self.client = nil
    self.open_id = nil
end

function Player:connect(ip, port, lobby_id, verify_code)
    log_info("[Player][connect] {} connect {}:{}", self.player_id, ip, port)
    self.client = GateClient(ip, port, self.player_id, lobby_id, verify_code)
    self.client:start()
end

function Player:on_gate_connected()
    log_info("[Player][on_gate_connected] connect gateway server success")
    self:login_player()
end

function Player:login_player()
    local data = { openid = self.open_id, player_id = self.player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_LOGIN_REQ", data)
    if qfailed(res.error_code, ok) then
        log_info("[Player][login_player] login player failed: {}", res)
        self.client:close()
    end
    event_mgr:notify_trigger("on_login_player_callback", ok)
end

function Player:logout_player(player_id)
    local data = { open_id = self.open_id, player_id = player_id }
    local ok, res = self.client:call("NID_LOGIN_PLAYER_LOGOUT_REQ", data)
    if qfailed(res.error_code, ok) then
        log_err("[Player][logout_player] logout player failed: {}", res)
    end
    event_mgr:notify_trigger("on_logout_player_callback")
    log_info("[Account][logout_player] logout player: {} success!", player_id)
end

return Player
