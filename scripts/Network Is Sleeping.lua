-- This script makes players, who are using velocity to manipulate baseparts, appear laggy!
-- Perfect for trolling annoying skids/leeches!

local Target = [[ AnthonyIsntHere ]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local function Message(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle,Text = MText,Icon = "rbxassetid://2541869220",Duration = Time})
end

local function GetPlayer(Name)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    Name = Name:lower():gsub(" ","")
    for _,x in next, Players:GetPlayers() do
        if x ~= LocalPlayer then
            if x.Name:lower():match("^"..Name) then
                return x
            elseif x.DisplayName:lower():match("^"..Name) then
                return x
            end
        end
    end
end

if not GetPlayer(Target) then
    return Message("Error:","Target not valid.")
elseif GetPlayer(Target).Name == Player.Name then
    return Message("Error:","Target is equal to Player.")
end

local TargetMetaVars = {}

TargetMetaVars["TPlayer"] = GetPlayer(Target)
TargetMetaVars["TCharacter"] = TargetMetaVars["TPlayer"].Character or false

local ErrorCheck = false

for _,x in next, TargetMetaVars do
    if not x then
        Message("Error:", "Target".._.." not valid.")
        ErrorCheck = true
    end
end

if ErrorCheck then return end

local Set_Hidden = sethiddenproperty

while RunService.Stepped:wait() do
    for _,x in next, TargetMetaVars.TCharacter:GetDescendants() do
        if x:IsA("BasePart") then
            Set_Hidden(x, "NetworkIsSleeping", true)
            --x.Velocity = Vector3.new(100, 100, 100)
        end
    end
end
