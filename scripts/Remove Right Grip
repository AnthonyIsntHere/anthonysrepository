--Made by AnthonyIsntHere
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")

local Tools = {}

if not Humanoid then return end
Humanoid:UnequipTools()

for _, x in next, Player.Backpack:GetChildren() do
    if x:IsA("Tool") and x:FindFirstChild("Handle") then
        table.insert(Tools, x)
        Humanoid:EquipTool(x)
    end
end

Humanoid:UnequipTools()

for _, x in next, Tools do
    x.Parent = Character
    x.Parent = Player.Backpack
    x.Parent = Humanoid
    x.Parent = Character
end
