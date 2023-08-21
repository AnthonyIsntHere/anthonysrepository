-- BANG SCRIPT
-- Inspired by CJ (murdaware/ou1z)
-- Made by AnthonyIsntHere

local Target = [[ AnthonyIsntHere ]]

local Players = game:GetService("Players")

local GetPlayer = function(Name)
    Name = Name:lower():gsub("%s", "")

    for _,x in next, Players:GetPlayers() do
        if x ~= Player then
            if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                return x
            elseif x.DisplayName:lower():match("^" .. Name) then
                return x
            end
        end
    end

    return false
end

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart or false

local TPlayer = GetPlayer(Target)
local TCharacter = TPlayer and TPlayer.Character
local THumanoid = TCharacter and TCharacter:FindFirstChildWhichIsA("Humanoid")
local TRootPart = THumanoid and THumanoid.RootPart or false

if not RootPart or not TRootPart then return warn("error XD") end

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

local i = 0
while Player.Character == Character and TPlayer.Parent == Players and TPlayer.Character == TCharacter do
    i += .35
    if THumanoid.FloorMaterial == Enum.Material.Air and Humanoid.FloorMaterial ~= Enum.Material.Air and THumanoid.SeatPart == nil and RootPart.Velocity.Y < 1 then
        i = 0
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    if THumanoid.SeatPart == nil then
        Humanoid:MoveTo((TRootPart.CFrame * CFrame.new(0, 0, 1.5 + math.sin(i) * 1.5)).p)
    else
        Humanoid:MoveTo((TRootPart.CFrame * CFrame.new(0, 0, -1.5 + math.sin(i) * 1.5)).p)
    end
    RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(TRootPart.Position.X, RootPart.Position.Y, TRootPart.Position.Z))
    task.wait()
end
