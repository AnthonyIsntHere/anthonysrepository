-- Made by AnthonyIsntHere
-- I did not make this method I just made the script Lol
-- Once u respawn js use any fd script or use anim id player or sum idk XD
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local ResetBind = Instance.new("BindableEvent")

local Player = Players.LocalPlayer
local Character = Player.Character

local Camera = workspace.CurrentCamera

replicatesignal(Player.ConnectDiedSignalBackend)
task.wait(Players.RespawnTime - .1)
replicatesignal(Player.Kill)

Character = Player.CharacterAdded:wait()
local Animate = Character:WaitForChild("Animate", 1) do
	if Animate then
		Animate.Enabled = false
	end
end

local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Humanoid.RootPart or Character:WaitForChild("HumanoidRootPart")

local CollidableLimbs = {}
local Motors = {}

local CreateClone = function(C)
    if not C then 
        return
    else
        if not C.Archivable then
            C.Archivable = true
        end
    end

    local Clone = C:Clone()
    local CRootPart = Clone:WaitForChild("HumanoidRootPart")
	
	Player.Character = Clone

    Clone.Parent = workspace
    CRootPart.CFrame = RootPart.CFrame

    for _, x in next, Clone:GetDescendants() do
        if x:IsA("BasePart") then
			if x.Transparency ~= 1 then
				x.Transparency = 1
			end
			
			if x.CanCollide then
				x.CanCollide = false
				table.insert(CollidableLimbs, x)
			end
		elseif x:IsA("Decal") then
			if x.Transparency ~= 1 then
				x.Transparency = 1
			end
		end
    end

    return {
		["Character"] = Clone,
		["RootPart"] = Clone:WaitForChild("HumanoidRootPart")
	}
end

local Clone = CreateClone(Character)

for _, x in next, Character:GetDescendants() do
	if x:IsA("BasePart") and x.CanCollide then
		table.insert(CollidableLimbs, x)
	end
	if x:IsA("Motor6D") then
		table.insert(Motors, x)
	end
end

local CollisionLoop; CollisionLoop = RunService.PreSimulation:Connect(function()
	for _, x in next, CollidableLimbs do
		x.CanCollide = false
	end
end)

RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 2, 1, 100, 100)
Clone.RootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 2, 1, 100, 100)

local Animator = Humanoid:WaitForChild("Animator", 1) do
	if Animator then
		Animator:Destroy()
	end
end

local Animate = Clone.Character:WaitForChild("Animate", 1) do
	if Animate then
		Animate.Enabled = true
	end
end

local CFLoop; CFLoop = RunService.PostSimulation:Connect(function() 
	local tick = tick()

	for _, Motor in next, Motors do
		local CloneMotor = Clone.Character:FindFirstChild(Motor.Name, true)
		if CloneMotor and CloneMotor:IsA("Motor6D") then
			local DesiredCFrame = CloneMotor.Part0.CFrame:ToObjectSpace(CloneMotor.Part1.CFrame)
            local Delta = Motor.C0:Inverse() * DesiredCFrame * Motor.C1
			local Axis, Angle = Delta:ToAxisAngle()
			sethiddenproperty(Motor, "ReplicateCurrentOffset6D", Delta.Position)
			sethiddenproperty(Motor, "ReplicateCurrentAngle6D", Axis * Angle)
		end
	end

	RootPart.CFrame = Clone.RootPart.CFrame + Vector3.new(0, math.sin(tick * 15) * .004, 0)
	RootPart.AssemblyLinearVelocity = Vector3.zero
	RootPart.AssemblyAngularVelocity = Vector3.zero
end)

local ResetConnection; ResetConnection = ResetBind.Event:Connect(function()
	CollisionLoop:Disconnect()
	CFLoop:Disconnect()
	Clone.Character:Destroy()
	Player.Character = Character
	replicatesignal(Player.Kill)
end)

StarterGui:SetCore("ResetButtonCallback", ResetBind)
Player.CharacterAdded:wait()
StarterGui:SetCore("ResetButtonCallback", true)
