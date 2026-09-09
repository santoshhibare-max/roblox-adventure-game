-- Shooting Range Target Script
-- Place this script in EACH target part
-- Targets give gold when shot and respawn

local target = script.Parent
local GOLD_PER_HIT = 2
local RESPAWN_TIME = 3
local MAX_HEALTH = 30

local currentHealth = MAX_HEALTH
local isDead = false

-- Add humanoid for damage detection
local humanoid = target:FindFirstChild("Humanoid")
if not humanoid then
    humanoid = Instance.new("Humanoid")
    humanoid.Parent = target
end

humanoid.MaxHealth = MAX_HEALTH
humanoid.Health = MAX_HEALTH

-- Detect when target is hit
local function onTargetHit()
    if isDead then return end
    
    -- Find nearest player
    local Players = game:GetService("Players")
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - target.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    -- Give gold to nearest player
    if nearestPlayer then
        local inventoryRemote = game.ReplicatedStorage:FindFirstChild("InventorySystem")
        if inventoryRemote then
            inventoryRemote:InvokeServer("AddGold", GOLD_PER_HIT)
            print("🎯 " .. nearestPlayer.Name .. " shot target! +" .. GOLD_PER_HIT .. " gold")
        end
    end
end

-- When target takes damage
humanoid.Died:Connect(function()
    if isDead then return end
    isDead = true
    
    -- Fire hit event
    onTargetHit()
    
    -- Make target invisible/disappear
    target.Transparency = 1
    target.CanCollide = false
    
    -- Wait and respawn
    wait(RESPAWN_TIME)
    
    -- Reset
    isDead = false
    target.Transparency = 0
    target.CanCollide = true
    humanoid.Health = MAX_HEALTH
    
    print("🔄 Target respawned!")
end)

-- Alternative: Detect bullets/projectiles hitting
local function onTouched(hit)
    if isDead or hit.Parent == target then return end
    
    -- Check if hit by bullet (you can customize this)
    if hit.Name:find("Bullet") or hit.Name:find("bullet") then
        onTargetHit()
        humanoid.Health = 0
    end
end

target.Touched:Connect(onTouched)

print("🎯 Target script loaded for: " .. target.Name)
