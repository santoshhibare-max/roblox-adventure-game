-- Lock System
-- Manages locked doors and code verification

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local playerCodesStore = DataStoreService:GetDataStore("PlayerUnlockCodes")

local CORRECT_CODE_TIMEOUT = 300 -- 5 minutes
local unlockedPlayers = {}

local function verifyCode(player, code)
    local userId = player.UserId
    local success, playerCode = pcall(function()
        return playerCodesStore:GetAsync(userId)
    end)
    
    if success and playerCode == code then
        unlockedPlayers[userId] = true
        return true
    end
    return false
end

local function isPlayerUnlocked(player)
    return unlockedPlayers[player.UserId] or false
end

local function resetPlayerUnlock(player)
    unlockedPlayers[player.UserId] = nil
end

-- Create RemoteFunction for lock verification
local RemoteFunction = Instance.new("RemoteFunction")
RemoteFunction.Name = "LockSystem"
RemoteFunction.Parent = game.ReplicatedStorage

function RemoteFunction.OnServerInvoke(player, action, code)
    if action == "Unlock" then
        if verifyCode(player, code) then
            return {success = true, message = "Area unlocked!"}
        else
            return {success = false, message = "Incorrect code"}
        end
    elseif action == "CheckUnlock" then
        return isPlayerUnlocked(player)
    end
end

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    resetPlayerUnlock(player)
end)

print("Lock System loaded")
