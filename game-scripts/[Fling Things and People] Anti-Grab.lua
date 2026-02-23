-- No one will be able to grab or fling you
-- Game: https://www.roblox.com/games/6961824067/Fling-Things-and-People
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterEvents = ReplicatedStorage:WaitForChild("CharacterEvents")
local Struggle = CharacterEvents:WaitForChild("Struggle")

local Player = Players.LocalPlayer
local IsHeld = Player:WaitForChild("IsHeld")

while task.wait() do
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
	local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local LastCF = (RootPart and RootPart.AssemblyLinearVelocity.Magnitude < 20) and RootPart.CFrame or false

	if Humanoid and RootPart and IsHeld.Value then
		if Humanoid:GetStateEnabled(Enum.HumanoidStateType.Seated) then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		end

		Struggle:FireServer()

		if LastCF then
			for i = 1, 20 do
				RootPart.CFrame = LastCF
				RootPart.AssemblyLinearVelocity = Vector3.zero
				Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				task.wait()
			end
		end
	end
end
