--player_system.lua

local log_info          = logger.info

local my_account        = quanta.get("my_account")
local protobuf_mgr      = quanta.get("protobuf_mgr")

local PlayerSystem = singleton()

function PlayerSystem:__init()
    -- cs协议监听
    protobuf_mgr:register(self, "NID_ENTITY_ATTR_UPDATE_NTF", "on_entity_attr_update_ntf")
end

-- 会话需要关闭
function PlayerSystem:on_entity_attr_update_ntf(session, message, body)
    log_info("[PlayerSystem][on_entity_attr_update_ntf] body({})", body)
    local player = my_account:get_player()
    if player then
        player:load_attrs(body.attrs)
    end
end

quanta.player_system = PlayerSystem()

return PlayerSystem
