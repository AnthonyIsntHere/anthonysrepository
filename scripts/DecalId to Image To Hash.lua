--This script retreives the hash and image id of a decal id
--Credits: AnthonyIsntHere, CJ (murdawaree)

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
