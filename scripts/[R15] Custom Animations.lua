-- This is for R15 only
-- Place in autoexec
-- It utilizes animations made by roblox
-- You can change the ids to whatever you like only if you know what ur doing lol

if not game:IsLoaded() then
    game.Loaded:wait()
end

--local Walk = "http://www.roblox.com/asset/?id=2510202577" -- Rthro
--local Walk = "http://www.roblox.com/asset/?id=4211223236" -- new R15
--local Walk = "http://www.roblox.com/asset/?id=3489174223" -- new Zombie
local Walk = "http://www.roblox.com/asset/?id=507767714" -- R15

--local Run = "http://www.roblox.com/asset/?id=10921261968" -- Rthro
--local Run = "http://www.roblox.com/asset/?id=616163682" -- new Zombie
--local Run = "http://www.roblox.com/asset/?id=4211220381" -- new R15
--local Run = "http://www.roblox.com/asset/?id=616163682" -- Zombie
local Run = "https://www.roblox.com/asset/?id=507767714" -- R15

--local Jump = "http://www.roblox.com/asset/?id=2510197830" -- Rthro
local Jump = "http://www.roblox.com/asset/?id=507765000" -- R15

--local Idle_A = "http://www.roblox.com/asset/?id=10921258489" -- Rthro
--local Idle_A = "http://www.roblox.com/asset/?id=4211217646" -- new R15
--local Idle_A = "http://www.roblox.com/asset/?id=10921344533" -- Zombie
local Idle_A = "http://www.roblox.com/asset/?id=507766951" -- R15IdleYawn

--local Idle_B = "http://www.roblox.com/asset/?id=4211218409" -- new R15
local Idle_B = "http://www.roblox.com/asset/?id=5230599789" -- Bored Emote

local Fall = "http://www.roblox.com/asset/?id=507767968"

local Climb = "http://www.roblox.com/asset/?id=507765644"

local Swim = "http://www.roblox.com/asset/?id=507784897"

local SwimIdle = "http://www.roblox.com/asset/?id=507785072"

local Player = game:GetService("Players").LocalPlayer
local Bool = false

game:GetService("StarterPlayer").AllowCustomAnimations = true -- THANKS PEW

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
