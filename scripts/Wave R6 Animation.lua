-- Wave R6 Animation
-- Made by AnthonyIsntHere
local Id = 176236333

local Players = game:FindService("Players") or game:GetService("Players")
local Player = Players.LocalPlayer
local Backpack = Player.Backpack

local Character = Player.Character
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

local Hi = Instance.new("Tool", Backpack)
Hi.Name = "Hi"
Hi.CanBeDropped = false
Hi.RequiresHandle = false
Hi.ToolTip = "Hi :)"

local Anim = Instance.new("Animation", Character)
Anim.AnimationId = "rbxassetid://" .. Id
Anim = Humanoid:LoadAnimation(Anim)

Hi.Activated:Connect(function()
    Anim:Play(.25, 1, 1)
    Anim:AdjustSpeed(1)
    Anim.TimePosition = 0
end)

Hi.Unequipped:Connect(function()
    Anim:Stop()
end)
