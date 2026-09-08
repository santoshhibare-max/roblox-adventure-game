-- Cozy House Setup
-- This script initializes the cozy house and sets up spawn logic

local Players = game:GetService("Players")

local function onPlayerSpawned(player, character)
    print(player.Name .. " spawned in the cozy house")
    
    -- Initialize player
    local PlayerSetup = game.ReplicatedStorage:WaitForChild("PlayerSetup")
    -- You can call setup functions here if using ModuleScripts
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        onPlayerSpawned(player, character)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

print("Cozy House Setup loaded")
