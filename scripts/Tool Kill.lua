-- This is my best Tool Kill script (outdated but still works!)
local Target = [[ AnthonyIsntHere ]]

local LoopKill = false

local function GetPlayer(Name)
    local Players = game:GetService("Players");
    local LocalPlayer = Players.LocalPlayer;
    Name = Name:lower():gsub(" ","")
    for _,x in next, Players:GetPlayers() do
        if x ~= LocalPlayer then
            if x.Name:lower():match("^"..Name) then
                return x;
            elseif x.DisplayName:lower():match("^"..Name) then
                return x;
            end
        end
    end
end

local function Message(MTitle,MText,Time)
    game:GetService("StarterGui"):SetCore("SendNotification",{Title = MTitle, Text = MText, Icon = "rbxassetid://2541869220", Duration = Time}) 
end

local function Kill()
    if not GetPlayer(Target) then
        return Message("Error",">   Player does not exist.",5)
    end
    
    repeat game:GetService("RunService").Heartbeat:wait() until GetPlayer(Target).Character and GetPlayer(Target).Character:FindFirstChildOfClass("Humanoid") and GetPlayer(Target).Character:FindFirstChildOfClass("Humanoid").Health > 0
    local Player = game:GetService("Players").LocalPlayer
    local Character
    local Humanoid
    local RootPart
    local Tool
    local Handle
    
    local TPlayer = GetPlayer(Target)
    local TCharacter = TPlayer.Character
    local THumanoid
    local TRootPart
    
    if Player.Character ~= nil and Player.Character and Player.Character.Name == Player.Name then
        Character = Player.Character
    else
        return Message("Error",">   Missing Character")
    end
    if Character:FindFirstChildOfClass("Humanoid") then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
    else
        return Message("Error",">   Missing Humanoid")
    end
    if Humanoid and Humanoid.RootPart then
        RootPart = Humanoid.RootPart
    else
        return Message("Error",">   Missing RootPart")
    end
    if Character:FindFirstChildOfClass("Tool") then
        Tool = Character:FindFirstChildOfClass("Tool")
    elseif Player.Backpack:FindFirstChildOfClass("Tool") and Humanoid then
        Tool = Player.Backpack:FindFirstChildOfClass("Tool")
        Humanoid:EquipTool(Player.Backpack:FindFirstChildOfClass("Tool"))
    else
        return Message("Error",">   Missing Tool")
    end
    if Tool and Tool:FindFirstChild("Handle") then
        Handle = Tool.Handle
    else
        return Message("Error",">   Missing Tool's Handle")
    end
    
    --Target
    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    else
        return Message("Error",">   Missing Target Humanoid")
    end
    if THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    else
        return Message("Error",">   Missing Target RootPart")
    end
    
    if THumanoid.Sit then
        return Message("Error",">   Target is seated")
    end
    
    local OldCFrame = RootPart.CFrame
    
    Humanoid:Destroy()
    local NewHumanoid = Humanoid:Clone()
    NewHumanoid.Parent = Character
    NewHumanoid:UnequipTools()
    NewHumanoid:EquipTool(Tool)
    Tool.Parent = workspace

    local Timer = os.time()

    repeat
        if (TRootPart.CFrame.p - RootPart.CFrame.p).Magnitude < 500 then
            Tool.Grip = CFrame.new()
            Tool.Grip = Handle.CFrame:ToObjectSpace(TRootPart.CFrame):Inverse()
        end
        firetouchinterest(Handle,TRootPart,0)
        firetouchinterest(Handle,TRootPart,1)
        game:GetService("RunService").Heartbeat:wait()
    until Tool.Parent ~= Character or not TPlayer or not TRootPart or THumanoid.Health <= 0 or os.time() > Timer + .20
    Player.Character = nil
    NewHumanoid.Health = 0
    Player.CharacterAdded:wait()
    repeat game:GetService("RunService").Heartbeat:wait() until Player.Character:FindFirstChild("HumanoidRootPart")
    Player.Character.HumanoidRootPart.CFrame = OldCFrame
end

if not LoopKill then
    Kill()
else
    while true do
        Kill()
    end
end
