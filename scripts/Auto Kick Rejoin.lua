--This script makes it so that whenever you get kicked you will rejoin the same server

local TeleportService = game:GetService("TeleportService")
local ClientReplicator = game:GetService("NetworkClient").ClientReplicator
local CurrentServer = game["JobId"]

ClientReplicator.AncestryChanged:Connect(function()
    TeleportService:TeleportToPlaceInstance(game["PlaceId"], CurrentServer)
end)

--Line 12 is for testing
--game:GetService("Players").LocalPlayer:Kick()
