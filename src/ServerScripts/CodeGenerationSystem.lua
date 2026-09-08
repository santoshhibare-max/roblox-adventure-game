-- Code Generation System
-- Generates unique unlock codes for each player completing parkour

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local playerCodesStore = DataStoreService:GetDataStore("PlayerUnlockCodes")

local CODE_LENGTH = 6
local CODE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local function generateRandomCode()
    local code = ""
    for i = 1, CODE_LENGTH do
        local randomIndex = math.random(1, #CODE_CHARACTERS)
        code = code .. CODE_CHARACTERS:sub(randomIndex, randomIndex)
    end
    return code
end

local function assignCodeToPlayer(player)
    local userId = player.UserId
    local code = generateRandomCode()
    
    -- Store in DataStore
    local success, err = pcall(function()
        playerCodesStore:SetAsync(userId, code)
    end)
    
    if success then
        print("Generated code for " .. player.Name .. ": " .. code)
        -- Notify player (you can update this with GUI notification)
        return code
    else
        warn("Error saving code for " .. player.Name .. ": " .. err)
        return nil
    end
end

local function getPlayerCode(player)
    local userId = player.UserId
    local success, code = pcall(function()
        return playerCodesStore:GetAsync(userId)
    end)
    
    if success then
        return code
    else
        warn("Error retrieving code for " .. player.Name)
        return nil
    end
end

-- Public functions exposed via RemoteFunction
local RemoteFunction = Instance.new("RemoteFunction")
RemoteFunction.Name = "CodeSystem"
RemoteFunction.Parent = game.ReplicatedStorage

function RemoteFunction.OnServerInvoke(player, action, ...)
    if action == "GenerateCode" then
        return assignCodeToPlayer(player)
    elseif action == "GetCode" then
        return getPlayerCode(player)
    end
end

print("Code Generation System loaded")
