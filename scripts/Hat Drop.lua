--Made by AnthonyIsntHere
--not discovered by me
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")

local Camera = workspace.CurrentCamera

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 5)
local RootPart = Humanoid and Humanoid.RootPart or Character:WaitForChild("HumanoidRootPart", 5)
local Animator = Humanoid and Humanoid:WaitForChild("Animator", 5)

local OldCFrame = RootPart and RootPart.CFrame
local Torso = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso")

local AnimateScript = Character:WaitForChild("Animate", 1)
local FallValue = AnimateScript and AnimateScript:WaitForChild("fall", 1)
local FallAnimation = FallValue and FallValue:WaitForChild("FallAnim", 1) -- needed if game detects animation in their anti-cheat

local CustomFallAnimation = Instance.new("Animation", CoreGui) -- needed if game uses custom animations
local CameraPart = Instance.new("Part")
local ResetBind = Instance.new("BindableEvent")

local FallAnimations = {
	[Enum.HumanoidRigType.R6] = "180436148",
	[Enum.HumanoidRigType.R15] = "507767968"
}

local RigId = FallAnimations[Humanoid.RigType]
local SetPos = false

local PlayAnimation = function(Anim)
	local Track = Animator:LoadAnimation(Anim)
	Track.Priority = Enum.AnimationPriority.Action
	Track.TimePosition = .1
	Track:Play()
	Track:AdjustWeight(5)
	return Track
end

if FallAnimation then
	if not FallAnimation.AnimationId:match(RigId) then
		FallAnimation.AnimationId = string.format("rbxassetid://%s", RigId)
	end
	CustomFallAnimation = FallAnimation
else
	CustomFallAnimation.AnimationId = RigId
end

local OldGravity = workspace.Gravity < 196.2 and workspace.Gravity or 196.2

workspace.Gravity = 0
workspace.FallenPartsDestroyHeight = 0/0
local ResetFPDH = task.spawn(function()
	Player.CharacterAdded:Wait()
	workspace.FallenPartsDestroyHeight = -500
	StarterGui:SetCore("ResetButtonCallback", true)
end)

if not Humanoid.BreakJointsOnDeath then
	Humanoid.BreakJointsOnDeath = true
end

CameraPart.Transparency = 1
CameraPart.Anchored = true
CameraPart.CFrame = Camera.Focus

Debris:AddItem(CameraPart)

for _, Accessory in next, Humanoid:GetAccessories() do
	sethiddenproperty(Accessory, "BackendAccoutrementState", 3)
end

local ResetConnection; ResetConnection = ResetBind.Event:Connect(function()
	replicatesignal(Player.ConnectDiedSignalBackend)
end)

StarterGui:SetCore("ResetButtonCallback", ResetBind)

local DropCFrame = CFrame.new(RootPart.Position.X, -500, RootPart.Position.Z)

if Humanoid.RigType == Enum.HumanoidRigType.R15 then
	DropCFrame *= CFrame.Angles(math.rad(45), 0, 0)
	Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	PlayAnimation(CustomFallAnimation)
else
	PlayAnimation(CustomFallAnimation)
end

local Float = task.spawn(function()
	while RootPart.Parent do
		RootPart.CFrame = DropCFrame
		RootPart.Velocity = Vector3.new()
		RootPart.RotVelocity = Vector3.new()
		RunService.PostSimulation:Wait()
	end
end)

local SetPos = task.spawn(function()
	while Player.Character == Character do
		for _, Accessory in next, Humanoid:GetAccessories() do
			if Accessory:IsA("Accessory") then
				local Handle = Accessory:FindFirstChild("Handle")

				if Handle and Handle.CanCollide then
					Handle.CFrame = OldCFrame
					Handle.Velocity = Vector3.new(0, 30, 0)
				end
			end
		end

		task.wait()
	end
end)

task.wait(.20)

Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
Torso.AncestryChanged:Wait()

task.cancel(Float)
task.delay(.25, function()
	task.cancel(SetPos)
end)

Camera.CameraSubject = CameraPart
workspace.Gravity = OldGravity
