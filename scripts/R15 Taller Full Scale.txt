local Settings = {
    Values = {
        BodyTypeScale = true;
        BodyProportionScale = false;
        BodyWidthScale = true;
        BodyHeightScale = true;
        BodyDepthScale = true;
        HeadScale = true;
    };
    OriginalSize = true;
    OriginalPosition = true;
}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local WaitFunc = function(x) x.DescendantAdded:wait() task.wait() end

if Humanoid.RigType == Enum.HumanoidRigType.R6 then return end

for _,x in next, Settings.Values do
    if x then
        if Settings.OriginalSize then --Specific Path/Settings
            for _, _os in next, Character:GetDescendants() do
                if _os.Name == "OriginalSize" and _os:IsA("ValueBase") then
                    _os:Destroy()
                end
            end
        end
        if Settings.OriginalPosition then
            for _, _op in next, Character:GetDescendants() do
                if _op.Name == "OriginalPosition" and _op:IsA("ValueBase") then
                    _op:Destroy()
                end
            end
        end
        if Humanoid:FindFirstChild(tostring(_)) then
            Humanoid:FindFirstChild(tostring(_)):Destroy()
        end
        WaitFunc(Character)
    end
end
