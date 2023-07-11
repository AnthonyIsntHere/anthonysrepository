-- Control Tool
-- Made by AnthonyIsntHere

-- You can select a specific tool by equipping it.
-- Hold tool out for instant ownership when loading (optional)
-- Movement (Flight-Based): Q, E, W, A, S, D
-- Fling is toggleable
-- You can reset normally using roblox menu

-- Settings:
local MaxSpeed = 1
local FlingHotkey = "X"
local FlingPower = 69420

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local Backpack = Player.Backpack
local Character = Player.Character or workspace:FindFirstChild(Player.Name, true)

local Tool = Character:FindFirstChildWhichIsA("Tool") or Backpack:FindFirstChildWhichIsA("Tool")
local Handle = Tool and Tool:FindFirstChild("Handle")

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart

if not (Handle or RootPart) then
    return warn("Error occurred")
end

local ResetBind = Instance.new("BindableEvent")

if workspace.FallenPartsDestroyHeight ~= -500 then
    workspace.FallenPartsDestroyHeight = -500
end

Player.Character = nil
Player.Character = Character
task.wait(Players.RespawnTime + .10)

local OldRPos = RootPart.Position

Humanoid:EquipTool(Tool)
repeat task.wait() until Character:FindFirstChildWhichIsA("Tool")
Humanoid:UnequipTools()

repeat
    Player:Move(Vector3.new(1/0))
    task.wait()
until Humanoid.Health == 0

-- RootPart.CFrame = CFrame.new(0, -499, 0)
-- repeat task.wait(.1) until (RootPart.Position - OldRPos).Magnitude > 100
-- Humanoid.Health = 0

repeat task.wait() until not Character:FindFirstChildWhichIsA("BasePart")

Humanoid:EquipTool(Tool)
Camera.CameraSubject = Handle

Handle.Name = "HumanoidRootPart"
Handle.Parent = Character

local Control = function()
    local Speed = 0
    local Keys = {
        Q = false,
        E = false,
        W = false,
        A = false,
        S = false,
        D = false
    }

    local BodyPosition = Instance.new("BodyPosition", Handle)
    local BodyGyro = Instance.new("BodyGyro", Handle)

    BodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BodyPosition.Position = Handle.Position

    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = Handle.CFrame

    UserInputService.InputBegan:Connect(function(Input, Typing)
        if not Typing then
            if not Keys[Input.KeyCode.Name] then
                Keys[Input.KeyCode.Name] = true
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(Input, Typing)
        if not Typing then
            if Keys[Input.KeyCode.Name] then
                Keys[Input.KeyCode.Name] = false
            end
        end
    end)

    local ResetConnection; ResetConnection = ResetBind.Event:Connect(function()
        if BodyPosition and BodyGyro then
            BodyPosition:Destroy()
            BodyGyro:Destroy()
        end
        Player.Character = nil
        Player.Character = Character
    end)

    task.spawn(function()
        while BodyPosition and BodyGyro do
            local New = BodyGyro.CFrame - BodyGyro.CFrame.p + BodyPosition.Position

            if not (Keys.Q and Keys.E and Keys.W and Keys.A and Keys.S and Keys.D) then
                Speed = MaxSpeed * .75
            end

            if Keys.Q then
                New = New * CFrame.new(0, -Speed / 2, 0)
            end

            if Keys.E then
                New = New * CFrame.new(0, Speed / 2, 0)
            end

            if Keys.W then
                New = New + Camera.CoordinateFrame.LookVector * Speed
                Speed += .01
            end

            if Keys.A then
                New = New * CFrame.new(-Speed, 0, 0)
                Speed += .01
            end

            if Keys.S then
                New = New - Camera.CoordinateFrame.LookVector * Speed
                Speed += .01
            end

            if Keys.D then
                New = New * CFrame.new(Speed, 0, 0)
                Speed += .01
            end

            if Speed > MaxSpeed then
                Speed = MaxSpeed
            end

            BodyPosition.position = New.p

            if Keys.W then
                BodyGyro.CFrame = Camera.CoordinateFrame * CFrame.Angles(-math.rad(Speed * 5), 0, 0)
            elseif Keys.S then
                BodyGyro.CFrame = Camera.CoordinateFrame * CFrame.Angles(math.rad(Speed * 5), 0, 0)
            else
                BodyGyro.CFrame = Camera.CoordinateFrame
            end

            task.wait()
        end
    end)

    local FlingDebounce = false

    UserInputService.InputBegan:Connect(function(Key, Typing)
        if not Typing and Key.KeyCode == Enum.KeyCode[FlingHotkey] then
            if not FlingDebounce then
                FlingDebounce = true
            else
                FlingDebounce = false
            end
        end
    end)

    task.spawn(function()
        while Player.Character == Character do
            if FlingDebounce then
                local Velocity = Handle.Velocity
                Handle.Velocity = Velocity + (Handle.CFrame.LookVector * FlingPower) + Vector3.new(0, FlingPower, 0)
                RunService.RenderStepped:wait()
                Handle.Velocity = Velocity
            end
            task.wait()
        end
    end)

    StarterGui:SetCore("ResetButtonCallback", ResetBind)
    Player.CharacterAdded:wait()
    StarterGui:SetCore("ResetButtonCallback", true)
end

Control()
