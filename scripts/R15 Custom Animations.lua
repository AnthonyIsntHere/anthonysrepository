-- This is for R15 only
-- Place in autoexec
-- It utilizes animations made by roblox
-- You can change the ids to whatever you like only if you know what ur doing lol

if not game:IsLoaded() then
    game.Loaded:wait()
end

local Walk = "http://www.roblox.com/asset/?id=2510202577"

local Run = "http://www.roblox.com/asset/?id=507777826"

local Jump = "http://www.roblox.com/asset/?id=2510197830"

local Idle_A = "http://www.roblox.com/asset/?id=742637544"

local Idle_B = "http://www.roblox.com/asset/?id=5230599789"

local Fall = "http://www.roblox.com/asset/?id=2510195892"

local Climb = "http://www.roblox.com/asset/?id=707826056"

local Swim = "http://www.roblox.com/asset/?id=657560551"

local SwimIdle = "http://www.roblox.com/asset/?id=657557095"

local Player = game:GetService("Players").LocalPlayer
local Bool = false

local function Animate(Character)
    local Humanoid
    
    local TimeToWait = 5
    local Time = os.time()
    
    repeat
        if Character and Character:FindFirstChildOfClass("Humanoid") then
            Humanoid = Character:FindFirstChildOfClass("Humanoid")
            break
        end
        game:GetService("RunService").Heartbeat:wait()
    until os.time() > Time + TimeToWait - 1
    
    local Animate = Character and Character:WaitForChild("Animate")
    
    if not Humanoid then 
        return
    elseif Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6 then
        Bool = true
        return
    end

    if not Animate then return end
    
    pcall(function()
        Animate:WaitForChild("walk"):WaitForChild("WalkAnim").AnimationId = Walk
        Animate:WaitForChild("run"):WaitForChild("RunAnim").AnimationId = Run
        Animate:WaitForChild("jump"):WaitForChild("JumpAnim").AnimationId = Jump
        Animate:WaitForChild("idle"):WaitForChild("Animation1").AnimationId = Idle_A
        Animate:WaitForChild("idle"):WaitForChild("Animation2").AnimationId = Idle_B
        Animate:WaitForChild("idle"):WaitForChild("Animation1"):WaitForChild("Weight").Value = "9"
        Animate:WaitForChild("idle"):WaitForChild("Animation2"):WaitForChild("Weight").Value = "1"
        Animate:WaitForChild("fall"):WaitForChild("FallAnim").AnimationId = Fall
        Animate:WaitForChild("climb"):WaitForChild("ClimbAnim").AnimationId = Climb
        Animate:WaitForChild("swim"):WaitForChild("Swim").AnimationId = Swim
        Animate:WaitForChild("swimidle"):WaitForChild("SwimIdle").AnimationId = SwimIdle
    end)
end

--if not Bool and Player.UserId == 1414978355 or Player.UserId == 3314699734 then
	Animate(Player.Character or Player.CharacterAdded:wait())

	Player.CharacterAdded:Connect(function(Character)
    	Animate(Character)
	end)
--end
