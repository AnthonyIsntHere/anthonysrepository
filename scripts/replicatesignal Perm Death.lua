local Players = game:GetService("Players")
local Player = Players.LocalPlayer

if not replicatesignal then
    return warn("Incompatible Executor")
end

replicatesignal(Player.ConnectDiedSignalBackend)
task.wait(Players.RespawnTime + .15)
replicatesignal(Player.Kill)
