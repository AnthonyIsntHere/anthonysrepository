-- One of my more older script remakes

local Target = "Anthony"

local function GetPlayer(Name)
    Name = Name:lower()
    for _,x in next, game:GetService("Players"):GetPlayers() do
        if string.lower(x.Name):find(Name) == 1 then
            return x
        end
    end
end
local function Message(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle;Text = MText;Duration = Time;})
end

if not GetPlayer(Target) then
    return Message("Error",">   Player does not exist.",5)
end

repeat game:GetService("RunService").Heartbeat:wait() until GetPlayer(Target).Character and  GetPlayer(Target).Character:FindFirstChildOfClass("Humanoid").Health > 0 or not GetPlayer(Target)

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local Humanoid
local HumanoidRootPart
local Torso
local Tool
local Handle

local TPlayer = GetPlayer(Target)
local TCharacter = TPlayer.Character
local THumanoid
local THumanoidRootPart
local TTorso

if Character:FindFirstChild("HumanoidRootPart") then
    HumanoidRootPart = Character.HumanoidRootPart
end
if Character:FindFirstChild("Torso") then
    Torso = Character.Torso
end
if Character:FindFirstChildOfClass("Humanoid") then
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
end
if Character:FindFirstChildOfClass("Tool") then
    Tool = Character:FindFirstChildOfClass("Tool")
elseif Player.Backpack:FindFirstChildOfClass("Tool") and Humanoid then
    Tool = Player.Backpack:FindFirstChildOfClass("Tool")
    Humanoid:EquipTool(Player.Backpack:FindFirstChildOfClass("Tool"))
end
if Tool and Tool:FindFirstChild("Handle") then
    Handle = Tool.Handle
end
if TCharacter:FindFirstChild("HumanoidRootPart") then
    THumanoidRootPart = TCharacter.HumanoidRootPart
end
if TCharacter:FindFirstChild("Torso") then
    TTorso = TCharacter.Torso
elseif TCharacter:FindFirstChild("UpperTorso") then
    TTorso = TCharacter.UpperTorso
end
if TCharacter:FindFirstChildOfClass("Humanoid") then
    THumanoid = Character:FindFirstChildOfClass("Humanoid")
end
if not HumanoidRootPart then
    Message("Error",">   Missing HumanoidRootPart, Trying Torso.",5)
    wait(1)
    if Torso then
        Message("Succes",">   Torso found.",5)
        wait(1)
        else Message("Error",">   Missing Torso") return
    end
end
if Humanoid.RigType == Enum.HumanoidRigType.R15 then
    Message("Error",">   Must be R6 to use this script.",5)
    wait(1)
    return
end
if not Tool then
    Message("Error",">   You have no tools.",5)
    wait(1)
    return
end
if not Handle then
    Message("Error",">   Tool doesn't have handle.",5)
    wait(1)
    return
end
if not THumanoidRootPart then
    Message("Error",">   Missing HumanoidRootPart on Target, Trying Torso.",5)
    wait(1)
    if Torso then
        Message("Succes",">   Torso found on Target.",5)
        wait(1)
        else Message("Error",">   Missing Torso on Target",5) return
    end
end

Humanoid:Destroy()
local NewHumanoid = Instance.new("Humanoid",Character)
NewHumanoid:UnequipTools()
NewHumanoid:EquipTool(Tool)
Tool.Parent = workspace

repeat
    Tool.Grip = CFrame.new()
    Tool.Grip = Handle.CFrame:ToObjectSpace(TTorso.CFrame):Inverse()
    firetouchinterest(Handle,TTorso,0)
    firetouchinterest(Handle,TTorso,1)
    game:GetService("RunService").Heartbeat:wait()
until Tool.Parent ~= Character
Player.Character = nil
NewHumanoid.Health = 0
