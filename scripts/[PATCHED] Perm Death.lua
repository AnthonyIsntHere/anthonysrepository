-- RIP TO ONE OF THE MOST OG METHODS LOL PATCHED ON 8/1/2023
-- It was fun while it lasted 2019-2023
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character ~= nil and Player.Character or workspace:FindFirstChild(tostring(Player), true)
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")

if not Humanoid then
    return
end

Player.Character = nil
Player.Character = Character
wait(Players.RespawnTime + .1) -- If it doesn't work the first time, extend .1 to .5/higher value
Humanoid.Health = 0
