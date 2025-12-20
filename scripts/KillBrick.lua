-- made by vnware/vnpleo <@968953495535362068> amazing person <3
-- this script makes it so you can instantly void players like grippos nan lol
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
local RootPart = Humanoid and Humanoid.RootPart

if Humanoid and RootPart then
	while Player.Character == Character do
		sethiddenproperty(Humanoid, "MoveDirectionInternal", Vector3.new(0/0))
		task.wait()
	end
end
