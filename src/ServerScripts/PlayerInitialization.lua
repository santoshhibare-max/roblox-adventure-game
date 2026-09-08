-- Player Initialization Script
-- Place this in ServerScriptService to give players starting gold and ammo

local Players = game:GetService("Players")

local STARTING_GOLD = 500  -- Give players 500 gold to start
local STARTING_AMMO = 30   -- Give players 30 ammo to start

local function initializePlayer(player)
    wait(0.5) -- Wait for inventory system to load
    
    local inventorySystem = game.ReplicatedStorage:FindFirstChild("InventorySystem")
    if not inventorySystem then
        warn("InventorySystem not found for " .. player.Name)
        return
    end
    
    -- Give starting gold
    local goldResult = inventorySystem:InvokeServer("AddGold", STARTING_GOLD)
    print(player.Name .. " received " .. STARTING_GOLD .. " starting gold. Total: " .. goldResult)
    
    -- Give starting ammo
    local ammoResult = inventorySystem:InvokeServer("AddAmmo", STARTING_AMMO)
    print(player.Name .. " received " .. STARTING_AMMO .. " starting ammo. Total: " .. ammoResult)
end

local function onPlayerAdded(player)
    initializePlayer(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Initialize existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

print("Player Initialization Script loaded")
