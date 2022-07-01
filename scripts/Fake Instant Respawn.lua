local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character = Player.Character ~= nil and Player.Character or workspace:FindFirstChild(tostring(Player), true)
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart
local PosOld, CamOld

local Camera = workspace.CurrentCamera

Player.Character = nil
Player.Character = Character
wait(Players.RespawnTime - .05) -- If doesn't work first time, extend .05 to .1 or more
if (Humanoid and RootPart and Camera) then
    Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    PosOld = RootPart.CFrame
    CamOld = Camera.CFrame
end
Character = Player.CharacterAppearanceLoaded:wait()
Humanoid = Character:FindFirstChildWhichIsA("Humanoid") or Character:WaitForChild("Humanoid")
RootPart = Humanoid and Humanoid.RootPart
if (Humanoid and RootPart and PosOld and CamOld) then
    RootPart.CFrame = PosOld
    Camera.CFrame = CamOld
end
