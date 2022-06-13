--This script prevents tkill from actually killing you lol

--Credits: AnthonyIsntHere, CJ (murdawaree)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local Camera = workspace.CurrentCamera

local GetCameraChanged = function()
   Camera = workspace.CurrentCamera 
end

local AntiKill = function()
    local Character = Player.Character or false
    local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid") or false
    local RootPart = Humanoid and Humanoid.RootPart or false
    if Character and Humanoid and RootPart and Camera then
        if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
            local X, Y, Z = Camera.CFrame:ToEulerAnglesYXZ()
	        RootPart.CFrame = CFrame.new(RootPart.Position) * CFrame.Angles(0, Y, 0)
        end
        
        Humanoid.Sit = true
        Humanoid:SetStateEnabled("Seated", false)
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(GetCameraChanged)
RunService.RenderStepped:Connect(AntiKill)
