-- Sieg Heil R6 Animation
-- Made by AnthonyIsntHere
local Id = 176236333

local Players = game:FindService("Players") or game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player.Backpack

local Character = Player.Character
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

local SiegHeil = Instance.new("Tool", Backpack)
SiegHeil.Name = "Sieg Heil"
SiegHeil.CanBeDropped = false
SiegHeil.RequiresHandle = false
SiegHeil.ToolTip = "Slaughter The Jews!"

local Anim = Instance.new("Animation", Character)
Anim.AnimationId = "rbxassetid://"..Id
Anim = Humanoid:LoadAnimation(Anim)

SiegHeil.Equipped:Connect(function()
    Anim:Play()
    Anim:AdjustSpeed(0)
    Anim.TimePosition = .1
end)

SiegHeil.Unequipped:Connect(function()
    Anim:Stop()
end)
