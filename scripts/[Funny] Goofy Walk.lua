local plr = game.Players.LocalPlayer
local char = plr.Character
local Hum = char.Humanoid

while wait() do
    Hum:ChangeState("FallingDown")
    wait(.15)
    Hum:ChangeState("GettingUp")
    Hum:ChangeState("RunningNoPhysics")
end
