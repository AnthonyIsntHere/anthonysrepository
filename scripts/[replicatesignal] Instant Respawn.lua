local Players = game:GetService("Players")
local Player = Players.LocalPlayer

if not replicatesignal then
    return warn("Incompatible Executor")
end

replicatesignal(Player.ConnectDiedSignalBackend)
task.wait(Players.RespawnTime - .01) -- Change to .1 if it doesn't work the first time
replicatesignal(Player.Kill)
