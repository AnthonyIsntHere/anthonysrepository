-- Note: click off if you're easily offended

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SayMessageRequest = ReplicatedStorage:FindFirstChild("SayMessageRequest", true)

local Player = Players.LocalPlayer
local Character = Player.Character

local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart

local Torso = Character and Character:FindFirstChild("Torso")
local Head = Character and Character:FindFirstChild("Head")

local BoomBox = Character and Character:FindFirstChild("BoomBox") or Player.Backpack:FindFirstChild("BoomBox")

local Ragdoll = function()
    for _, x in next, Character:GetDescendants() do
		if x:IsA("Motor6D") and not tostring(x):lower():match("root") then
			local BallSocket = Instance.new("BallSocketConstraint", x.Part0)
			
			local Attachment1 = Instance.new("Attachment", x.Part0)
			local Attachment2 = Instance.new("Attachment", x.Part1) 
			
			Attachment2.Position = x.C1.Position
			Attachment1.WorldPosition = Attachment2.WorldPosition

			BallSocket.LimitsEnabled = true
			BallSocket.TwistLimitsEnabled = true

			BallSocket.Attachment0 = Attachment1
			BallSocket.Attachment1 = Attachment2
		end
    end

    for _,x in next, Character.Torso:GetChildren() do
        if x:IsA("Motor6D") then
            x:Destroy()
        end
    end

    task.spawn(function()
        repeat
            for _, x in next, Character:GetChildren() do
                if x:IsA("BasePart") and x ~= RootPart or x ~= Torso then
                    x.CFrame = x.CFrame * CFrame.new(0, math.sin(tick() / math.pi * 9e9) / 100, 0)
                    x.AssemblyLinearVelocity = Vector3.new(Torso.AssemblyLinearVelocity.X * 10, -200, Torso.AssemblyLinearVelocity.Z * 10)
                    x.AssemblyAngularVelocity = Vector3.new(Torso.AssemblyAngularVelocity.X * 10, Torso.AssemblyAngularVelocity * 10, Torso.AssemblyAngularVelocity.Z * 10)  
                end
            end
            task.wait()
        until Player.Character ~= Character
    end)
end

local Say = function(Message, Time)
    SayMessageRequest:FireServer(Message, "All")
    task.wait(Time)
end

if BoomBox then
    BoomBox.Parent = Character
    BoomBox.Remote:FireServer("PlaySong", 5802007890)
    BoomBox.Server:Destroy()
end
wait(.5)

Say("Hey guys!", 1.90)
Say("I guess that's it.", 2.50)

local Clone = Humanoid:Clone()

Humanoid:Destroy()
Clone.Parent = Character

Ragdoll()

Clone:ChangeState(Enum.HumanoidStateType.Ragdoll)
Clone:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)

RootPart.Velocity = -RootPart.CFrame.LookVector * 500
Character.Head:Destroy()

if BoomBox then
    task.wait(BoomBox.Handle.Sound.TimeLength - BoomBox.Handle.Sound.TimePosition)
    BoomBox:Destroy()
end

repeat
    RootPart.Velocity = Vector3.new(math.random(-10, 10), math.random(-30, 30), math.random(-10, 10))
    wait(.1)
until Player.Character ~= Character
