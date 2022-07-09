-- Requires two or more tools
-- Equip tool of choice and execute; will parent tools to the tool of choice.

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character

local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local Tool = Character:FindFirstChildWhichIsA("Tool") or Player.Backpack:FindFirstChildWhichIsA("Tool")

Humanoid:UnequipTools()

for _, x in next, Player.Backpack:GetChildren() do
    if _ > 0 and x ~= Tool then
        x.Parent = Character
        x.Parent = Tool
        x.Parent = Player.Backpack
        x.Parent = Tool
    end
end
