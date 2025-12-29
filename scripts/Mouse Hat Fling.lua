--Made by AnthonyIsntHere
--Mouse Hat Fling
--Do NOT use in games with anti-cheats unless you know what you are doing! (Use my Instance Bypass script for bodymover detection :P)
local PermDeath = true

local CameraSpeed = .25
local Sensitivity = .005
local MaxRadius = 90

local Controls = {
	W = Vector3.new(0, 0, -1),
	A = Vector3.new(-1, 0, 0),
	S = Vector3.new(0, 0, 1),
	D = Vector3.new(1, 0, 0),
	E = Vector3.new(0, 1, 0),    
	Q = Vector3.new(0, -1, 0)
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local Camera = workspace.CurrentCamera

local KeysDown = {}
local Rotating = false

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 5)
local RootPart = Humanoid and Humanoid.RootPart or Character:WaitForChild("HumanoidRootPart", 5)
local Animator = Humanoid and Humanoid:WaitForChild("Animator", 5)

local Mouse = Player:GetMouse()

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
local SetPos, CanCollide = false, false

local KeysDownConnection, KeysUpConnection = false, false

local PlayAnimation = function(Anim)
	local Track = Animator:LoadAnimation(Anim)
	Track.Priority = Enum.AnimationPriority.Action
	Track.TimePosition = .1
	Track:Play()
	Track:AdjustWeight(5)
	return Track
end

local Notify = function(_Title, _Text , Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Icon = "rbxassetid://2541869220", Duration = Time})
end

Notify("Mouse Hat Fling", "Scripted by AnthonyIsntHere, enjoy! Loading...", 10)

if FallAnimation then
	if not FallAnimation.AnimationId:match(RigId) then
		FallAnimation.AnimationId = string.format("rbxassetid://%s", RigId)
	end
	CustomFallAnimation = FallAnimation
else
	CustomFallAnimation.AnimationId = string.format("rbxassetid://%s", RigId)
end

local OldGravity = workspace:GetAttribute("Gravity")
if not OldGravity then
	workspace:SetAttribute("Gravity", workspace.Gravity)
	OldGravity = workspace.Gravity
end

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

for _, Accessory in next, Humanoid:GetAccessories() do
	sethiddenproperty(Accessory, "BackendAccoutrementState", 3)
end

if PermDeath then
	replicatesignal(Player.ConnectDiedSignalBackend)
	task.wait(Players.RespawnTime)

	local ResetConnection; ResetConnection = ResetBind.Event:Connect(function()
		replicatesignal(Player.ConnectDiedSignalBackend)
		Notify("Mouse Hat Fling", "Resetting...")
	end)

	StarterGui:SetCore("ResetButtonCallback", ResetBind)
end

local DropCFrame = CFrame.new(Camera.Focus.Position.X, -500, Camera.Focus.Position.Z)

if Humanoid.RigType == Enum.HumanoidRigType.R15 then
	DropCFrame *= CFrame.Angles(math.rad(45), 0, 0)
	Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
	PlayAnimation(CustomFallAnimation)
else
	PlayAnimation(CustomFallAnimation)
end

Camera.CameraSubject = CameraPart

local Float = task.spawn(function()
	while RootPart.Parent do
		RootPart.Velocity = Vector3.new()
		RootPart.RotVelocity = Vector3.new()
		RunService.PreSimulation:Wait()
		RootPart.CFrame = DropCFrame
		RunService.PostSimulation:Wait()
	end
end)

local SetPos = task.spawn(function()
	while SetPos ~= nil do
		for _, Accessory in next, Humanoid:GetAccessories() do
			if Accessory:IsA("Accessory") then
				local Handle = Accessory:FindFirstChild("Handle")

				if Handle and Handle.CanCollide then
					Handle.CFrame = OldCFrame
					Handle.Velocity = Vector3.new(0, 30, 0)

					CanCollide = true
				end
			end
		end

		task.wait()
	end
end)

workspace.Gravity = 0
workspace.FallenPartsDestroyHeight = 0/0

task.wait(.25)

Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
Torso.AncestryChanged:Wait()

task.cancel(Float)
task.delay(.25, function()
	task.cancel(SetPos)
	
	workspace.Gravity = OldGravity

	if CanCollide then
		Notify("Mouse Hat Fling", "Hats are colliding.")
	else
		Notify("Error:", "Failed to load! Resetting...")

		if PermDeath then
			replicatesignal(Player.ConnectDiedSignalBackend)
		end
	end
end)

Camera.CameraSubject = CameraPart
Camera.CameraType = Enum.CameraType.Scriptable
Mouse.TargetFilter = Character

KeysDownConnection = UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		local Key = Input.KeyCode.Name
		if Controls[Key] then
			KeysDown[Key] = true
		end
	elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Rotating = true
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
	end
end)

KeysUpConnection = UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.Keyboard then
		local Key = Input.KeyCode.Name
		if Controls[Key] then
			KeysDown[Key] = false
		end
	elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Rotating = false
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end)

local LookVec = Camera.CFrame.LookVector
local Yaw, Radius = math.atan2(-LookVec.X, -LookVec.Z), math.asin(LookVec.Y)
local CameraConnection; CameraConnection = RunService.RenderStepped:Connect(function()
	if Player.Character ~= Character then
		CameraConnection:Disconnect()

		if CameraPart then
			CameraPart:Destroy()
		end

		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		Camera.CameraType = Enum.CameraType.Custom
		Camera.CameraSubject = Player.Character

		if KeysUpConnection and KeysDownConnection then
			KeysUpConnection:Disconnect()
			KeysDownConnection:Disconnect()
		end
	end

	local MouseDelta = UserInputService:GetMouseDelta()

	Yaw -= MouseDelta.X * Sensitivity
	Radius = math.clamp(Radius - MouseDelta.Y * Sensitivity, -math.rad(MaxRadius), math.rad(MaxRadius))

	local Rotation = CFrame.fromAxisAngle(Vector3.yAxis, Yaw) * CFrame.fromAxisAngle(Vector3.xAxis, Radius)
	local MoveDirection = Vector3.zero

	for x, y in next, Controls do
		if KeysDown[x] then
			MoveDirection += y
		end
	end

	if MoveDirection.Magnitude > 0 then
		MoveDirection = MoveDirection.Unit
	end

	local MoveCF = Rotation:VectorToWorldSpace(MoveDirection) * CameraSpeed
	Camera.CFrame = CFrame.new(Camera.CFrame.Position + MoveCF) * Rotation
end)

local HatFling = task.spawn(function()
	while Player.Character == Character do
		RunService.PostSimulation:wait()
		for _, Accessory in next, Humanoid:GetAccessories() do
			local Handle = Accessory:FindFirstChild("Handle")
			if Handle then
				Handle.Velocity = Vector3.new(1e20, 1e20, 1e20)
			end
		end
		RunService.RenderStepped:wait()
		for _, Accessory in next, Humanoid:GetAccessories() do
			local Handle = Accessory:FindFirstChild("Handle")
			if Handle then
				Handle.Velocity = Vector3.new(0, 30, 0)
			end
		end
	end
end)

while Player.Character == Character do
	for _, Accessory in next, Humanoid:GetAccessories() do
		local Handle = Accessory:FindFirstChild("Handle")
		local BodyPosition = Handle and Handle:FindFirstChildWhichIsA("BodyPosition") or Instance.new("BodyPosition", Handle)

		if Handle and BodyPosition then
			BodyPosition.Position = Mouse.Hit.Position + Vector3.new(0, 2, 0)
			BodyPosition.MaxForce = Vector3.new(1/0, 1/0, 1/0)
			BodyPosition.P = 1e10
		end
	end
	task.wait()
end
