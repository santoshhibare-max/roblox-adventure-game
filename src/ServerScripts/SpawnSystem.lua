-- Spawn System
-- Handles player spawning and respawning at spawn points

local Players = game:GetService("Players")
local SPAWN_LOCATION = workspace:FindFirstChild("SpawnLocation")
local SPAWN_DEBOUNCE = 2

local spawnDebounce = {}

local function teleportPlayerToSpawn(player)
    if not SPAWN_LOCATION then
        warn("SpawnLocation not found in workspace")
        return
    end
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character:MoveTo(SPAWN_LOCATION.Position + Vector3.new(0, 3, 0))
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        wait(0.1)
        teleportPlayerToSpawn(player)
    end)
end

local function onPlayerRemoving(player)
    spawnDebounce[player.UserId] = nil
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Teleport existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
