-- fencing uses leaderstat script that has while wait(5) do check and its just stupid ._.

syn.queue_on_teleport(
    [[
        game.Loaded:wait()
        local plrs = game.Players
        local plr = plrs.LocalPlayer
        
        local plrscripts = plr:WaitForChild("PlayerScripts")
        
        local char = plr.Character or plr.CharacterAdded:wait()
        
        repeat task.wait() until plrscripts:FindFirstChild("PlayerScriptsLoader")
        
        plr.Character = char:Destroy()
    ]]
)

game:GetService("TeleportService"):Teleport(game.PlaceId)
