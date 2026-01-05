--login_component.lua

local TcpClient = import("network/tcp_client.lua")

local LoginComponent = mixin()
local prop = property(LoginComponent)
prop:reader("client", nil)

function LoginComponent:__init()
end

--connect
function LoginComponent:connect()
    local ip, port = environ.addr("QUANTA_LOGIN_ADDR")
    self.client = TcpClient(ip, port)
end

return LoginComponent
