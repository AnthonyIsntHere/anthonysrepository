-- use smallest scale settings preferably 75% on width
local h = game:GetService("Players").LocalPlayer.Character.Humanoid

h.WalkSpeed = 10
h.JumpPower = 30

setfpscap(60)

for _,x in next, h:GetChildren() do
    for _,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
        if v:IsA("ValueBase") and v.Name == "OriginalSize" or v.Name == "OriginalPosition" then
            v:Destroy()
        end
    end
    if x:IsA("ValueBase") then
        if x.Name ~= "BodyProportionScale" and x.Name ~= "BodyHeightScale" then
            x:Destroy()
        end
    end
    wait(.20)
end

local ok = true

game.UserInputService.InputBegan:Connect(function(key,keyboard)
    if not keyboard and key.KeyCode == Enum.KeyCode.E then
        if ok then
            if h.MoveDirection.Magnitude == 0 then
                h.RootPart.Velocity = h.RootPart.CFrame.LookVector * 10
                h.RootPart.RotVelocity = Vector3.new(7.5, 0, 0)
            end
            h:ChangeState("FallingDown")
            h:SetStateEnabled("GettingUp", false)
            ok = false
        else
            h:SetStateEnabled("GettingUp", true)
             h:ChangeState("GettingUp")
            ok = true
        end
    end
end)
