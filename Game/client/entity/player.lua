--player.lua
local log_info      = logger.info

local event_mgr     = quanta.get("event_mgr")

local Player = mixin()
local prop = property(Player)
prop:reader("client", nil)
prop:reader("open_id", nil)
prop:reader("user_id", nil)
prop:reader("lobby_id", nil)
prop:reader("player_id", nil)
prop:reader("gate_port", nil)
prop:reader("gate_ip", nil)
prop:reader("players", {})

function Player:__init()
    event_mgr:add_trigger(self, "on_gate_connected")
end

function Player:on_gate_connected()
    log_info("[Player][on_gate_connected] connect gateway server success")
end

return Player
