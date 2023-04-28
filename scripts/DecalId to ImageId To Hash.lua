--This script converts a decal id to an imageid along with the hashed version.
--Credits: AnthonyIsntHere, ou1z

local DecalId = 3032537368

local GetImageFromDecal = function(DecalId)
    local Response = syn.request({
        Url = "https://assetdelivery.roblox.com/v1/asset/?id=" .. DecalId
    })
    
    return Response.Body:match("?id=(%d+)")
end

local GetHashFromImage = function(ImageId)
    local Response = syn.request({
        Url = "https://assetdelivery.roblox.com/v1/assetId/" .. ImageId
    })
    
    return Response.Body:match("com/(%w+)")
end

local ImageId = GetImageFromDecal(DecalId)
local Hash = GetHashFromImage(ImageId)

setclipboard(tostring("ImageId: "..ImageId.."\nHash: "..Hash))
