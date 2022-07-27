-- Requires two or more tools
-- Equip tool of choice and execute; will parent tools to the tool of choice.

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character

local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local NewParent = Character:FindFirstChildWhichIsA("Tool") or Player.Backpack:FindFirstChildWhichIsA("Tool") -- This can be anything that replicates within Character E.g. Player, Head, etc.

Humanoid:UnequipTools()

for _, x in next, Player.Backpack:GetChildren() do
    if x:IsA("Tool") and _ > 0 and x ~= NewParent then
        x.Parent = Character
        x.Parent = NewParent
        x.Parent = Player.Backpack -- required to finish change
        x.Parent = NewParent
    end
end
