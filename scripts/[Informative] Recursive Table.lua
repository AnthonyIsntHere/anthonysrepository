local Stuff = {
    "Neck";
    "Right Shoulder";
}

for _,x in next, Stuff do
    print(game:GetService("Players").LocalPlayer.Character:FindFirstChild(x, true))
end
