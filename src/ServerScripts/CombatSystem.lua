-- Combat System
-- Handles weapon mechanics, enemy AI, and combat interactions

local Players = game:GetService("Players")

local WEAPON_CONFIG = {
    Gun = {
        damage = 25,
        fireRate = 0.2,
        ammoPerShot = 1,
        range = 100
    }
}

local ENEMY_CONFIG = {
    ParallelCreature = {
        maxHealth = 50,
        damage = 10,
        speed = 16,
        detectionRange = 50,
        lootGold = 10
    }
}

local function damageEnemy(enemy, damage)
    if enemy:FindFirstChild("Humanoid") then
        enemy.Humanoid:TakeDamage(damage)
        return true
    end
    return false
end

local function fireWeapon(player, weapon, target)
    local config = WEAPON_CONFIG[weapon]
    if not config then return false end
    
    -- Check ammo
    local inventoryRemote = game.ReplicatedStorage:FindFirstChild("InventorySystem")
    if inventoryRemote then
        local hasAmmo = inventoryRemote:InvokeClient(player, "UseAmmo", config.ammoPerShot)
        if not hasAmmo then
            return {success = false, message = "Out of ammo!"}
        end
    end
    
    -- Deal damage to target
    if damageEnemy(target, config.damage) then
        return {success = true, damage = config.damage}
    end
    return {success = false, message = "Target not found"}
end

local function createEnemy(position, enemyType)
    local config = ENEMY_CONFIG[enemyType]
    if not config then return nil end
    
    -- Create basic enemy model (you'll add models in studio)
    local enemy = Instance.new("Part")
    enemy.Name = enemyType
    enemy.Shape = Enum.PartType.Block
    enemy.Size = Vector3.new(2, 3, 2)
    enemy.Position = position
    enemy.CanCollide = true
    enemy.Parent = workspace
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = enemy
    humanoid.MaxHealth = config.maxHealth
    humanoid.Health = config.maxHealth
    
    -- Add health check
    humanoid.Died:Connect(function()
        -- Drop loot
        local nearestPlayer = findNearestPlayer(position)
        if nearestPlayer then
            local inventoryRemote = game.ReplicatedStorage:FindFirstChild("InventorySystem")
            if inventoryRemote then
                inventoryRemote:InvokeClient(nearestPlayer, "AddGold", config.lootGold)
            end
        end
        wait(0.5)
        enemy:Destroy()
    end)
    
    return enemy
end

local function findNearestPlayer(position)
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    return nearestPlayer
end

-- RemoteFunction for combat actions
local RemoteFunction = Instance.new("RemoteFunction")
RemoteFunction.Name = "CombatSystem"
RemoteFunction.Parent = game.ReplicatedStorage

function RemoteFunction.OnServerInvoke(player, action, ...)
    if action == "FireWeapon" then
        local weapon, target = select(1, ...), select(2, ...)
        return fireWeapon(player, weapon, target)
    elseif action == "CreateEnemy" then
        local position, enemyType = select(1, ...), select(2, ...)
        return createEnemy(position, enemyType)
    end
end

print("Combat System loaded")
