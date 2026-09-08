-- Shop Zone Script
-- Place this script in a circular part (created in studio)
-- When player stands in circle and right-clicks, shop GUI opens

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local shopZone = script.Parent
local shopZoneSize = 30 -- Radius of detection zone in studs

local playersInZone = {}

-- Detect when player enters zone
local function onTouched(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local player = Players:FindFirstChild(hit.Parent.Name)
    if not player then return end
    
    playersInZone[player.UserId] = true
    print(player.Name .. " entered shop zone")
end

-- Detect when player leaves zone
local function onTouchEnded(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local player = Players:FindFirstChild(hit.Parent.Name)
    if not player then return end
    
    playersInZone[player.UserId] = false
    print(player.Name .. " left shop zone")
end

shopZone.Touched:Connect(onTouched)
shopZone.TouchEnded:Connect(onTouchEnded)

-- Send player list to local script
local shopRemote = Instance.new("RemoteFunction")
shopRemote.Name = "ShopZoneCheck"
shopRemote.Parent = game.ReplicatedStorage

function shopRemote.OnServerInvoke(player, action)
    if action == "IsInZone" then
        return playersInZone[player.UserId] or false
    end
end

print("Shop Zone Script loaded for: " .. shopZone.Name)
