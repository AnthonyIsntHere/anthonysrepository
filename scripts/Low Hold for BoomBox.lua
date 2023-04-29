local plr = game.Players.LocalPlayer
local bp = plr.Backpack

local char = plr.Character
local boombox = char and char:FindFirstChild("BoomBox") or bp:FindFirstChild("BoomBox")

if not boombox then return end

boombox.Parent = char

for _, x in next, char.Humanoid:GetPlayingAnimationTracks() do
    if x.Name == "ToolNoneAnim" then
        x:Stop()
    end
end

char.Animate.toolnone.ToolNoneAnim.AnimationId = ""

boombox.Grip = CFrame.new(0, .70, 0) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(90))
boombox.Parent = bp
boombox.Parent = char
