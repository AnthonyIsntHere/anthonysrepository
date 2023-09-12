-- Made by AnthonyIsntHere
-- Idk who needs this but this will tp u to the void killing people who use bang on you if they dont use workspace.FallenPartsDestroyHeight = 0/0 to bypass void limit

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local Character, Humanoid, RootPart

local Camera = workspace.CurrentCamera

local IsVoiding = false

local GetNearestPlayers = function()
    if RootPart then
        for _, x in next, Players:GetPlayers() do
            if x ~= Player then
                local x_Character = x.Character
                local x_Humanoid = x_Character and x_Character:FindFirstChildWhichIsA("Humanoid")
                local x_RootPart = x_Humanoid and x_Humanoid.RootPart

                if x_RootPart and (RootPart.Position - x_RootPart.Position).Magnitude < 2 then
                    for _, x in next, x_Humanoid:GetPlayingAnimationTracks() do
                        if x.Animation and x.Animation.AnimationId:match("148840371") or x.Animation.AnimationId:match("5918726674") then
                            return true
                        end
                    end

                    return false
                end
            end
        end
    end

    return false
end

workspace.FallenPartsDestroyHeight = 0 / 0

while true do
    Character = Player.Character
    Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")
    RootPart = Humanoid and Humanoid.RootPart

    if GetNearestPlayers() and Humanoid and RootPart and not IsVoiding then
        IsVoiding = true

        local CurrentPosition = RootPart.Velocity.Magnitude < 50 and RootPart.CFrame or Camera.Focus
        local Timer = tick()

        repeat
            RootPart.CFrame = CFrame.new(0, -499, 0) * CFrame.Angles(math.rad(90), 0, 0)
            RootPart.AssemblyLinearVelocity = Vector3.new()
            task.wait()
        until tick() > Timer + 1

        RootPart.AssemblyLinearVelocity = Vector3.new()
        RootPart.CFrame = CurrentPosition

        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        IsVoiding = false
    end

    task.wait()
end
