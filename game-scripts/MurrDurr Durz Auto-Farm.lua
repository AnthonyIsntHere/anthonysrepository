-- Made by AnthonyIsntHere
-- MurDurr Durz Auto-Farm
-- Game Link: https://www.roblox.com/games/79735281630764/MurDurr

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Obbies = workspace:FindFirstChild("Obbies")

local AwardParts = Obbies and Obbies:FindFirstChild("AwardParts")
local HardestAwardPart = AwardParts and AwardParts:FindFirstChild("Hardest")

local TeleportParts = Obbies and Obbies:FindFirstChild("TeleportParts")
local HardestTeleportPart = TeleportParts and TeleportParts:FindFirstChild("Hardest")

local TouchPart = function()
    local Character = Player.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not RootPart then return end
    local CurrentCoordinates = RootPart.CFrame
    repeat
        CurrentCoordinates = RootPart.CFrame
        local Response, OverlapError = pcall(function()
            firetouchinterest(RootPart, HardestAwardPart, 0); firetouchinterest(RootPart, HardestAwardPart, 1)
        end)
        task.wait()
    until (RootPart.Position - HardestTeleportPart.Position).Magnitude < 20
    RootPart.CFrame = CurrentCoordinates
end

if not HardestAwardPart or not HardestTeleportPart then
    return warn("patched lol")
end

while task.wait() do
    TouchPart()
end
