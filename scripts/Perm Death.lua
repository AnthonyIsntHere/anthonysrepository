local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character ~= nil and Player.Character or workspace:FindFirstChild(tostring(Player), true)

Player.Character = nil
Player.Character = Character
wait(Players.RespawnTime + .1) -- If doesn't work first time, extend .1 to .5
Character:BreakJoints() -- Kill method can be replaced if needed.
