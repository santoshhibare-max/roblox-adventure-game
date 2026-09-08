-- MASTER GAME INITIALIZATION SCRIPT
-- Consolidates: Money System + Code System + Inventory + Combat + Shop
-- Place this SINGLE script in ServerScriptService

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- ============================================
-- DATASTORES
-- ============================================
local inventoryStore = DataStoreService:GetDataStore("PlayerInventory")

-- ============================================
-- CONFIGURATION
-- ============================================
local CONFIG = {
    STARTING_MONEY = 500,      -- Starting money (gold)
    STARTING_AMMO = 30,
    PARKOUR_REWARD_GOLD = 150,
    AMMO_PRICE = 50,
    AMMO_AMOUNT = 30,
    GUN_PRICE = 200,
    CODE_LENGTH = 4,           -- Personal code length
    WEAPON_DAMAGE = 25,
    WEAPON_FIRE_RATE = 0.2,
    WEAPON_AMMO_PER_SHOT = 1,
    ENEMY_HEALTH = 50,
    ENEMY_DAMAGE = 10,
    ENEMY_LOOT_GOLD = 10
}

local CODE_CHARACTERS = "0123456789"

-- ============================================
-- DEFAULT INVENTORY
-- ============================================
local DEFAULT_INVENTORY = {
    ammo = 0,
    gold = 0,
    hasGun = false,
    upgrades = {}
}

-- ============================================
-- MONEY SYSTEM (From your script)
-- ============================================
local function initializeMoney(player)
    local money = Instance.new("IntValue")
    money.Name = "Money"
    money.Value = CONFIG.STARTING_MONEY
    money.Parent = player
    print("💰 " .. player.Name .. " received " .. CONFIG.STARTING_MONEY .. " starting money")
    return money
end

-- ============================================
-- CODE GENERATION (From your script)
-- ============================================
local function generateCode()
    local code = ""
    for i = 1, CONFIG.CODE_LENGTH do
        local randomIndex = math.random(1, #CODE_CHARACTERS)
        code = code .. CODE_CHARACTERS:sub(randomIndex, randomIndex)
    end
    return code
end

local function initializePersonalCode(player)
    local codeValue = Instance.new("StringValue")
    codeValue.Name = "PersonalCode"
    codeValue.Value = generateCode()
    codeValue.Parent = player
    print("🔐 " .. player.Name .. "'s personal code is " .. codeValue.Value)
    return codeValue
end

-- ============================================
-- INVENTORY FUNCTIONS (DataStore Version)
-- ============================================
local function getPlayerInventory(player)
    local userId = player.UserId
    local success, inventory = pcall(function()
        return inventoryStore:GetAsync(userId)
    end)
    
    if success and inventory then
        return inventory
    else
        return DEFAULT_INVENTORY
    end
end

local function savePlayerInventory(player, inventory)
    local userId = player.UserId
    local success = pcall(function()
        inventoryStore:SetAsync(userId, inventory)
    end)
    return success
end

local function addAmmo(player, amount)
    local inventory = getPlayerInventory(player)
    inventory.ammo = (inventory.ammo or 0) + amount
    savePlayerInventory(player, inventory)
    return inventory.ammo
end

local function useAmmo(player, amount)
    local inventory = getPlayerInventory(player)
    if (inventory.ammo or 0) >= amount then
        inventory.ammo = inventory.ammo - amount
        savePlayerInventory(player, inventory)
        return true
    end
    return false
end

local function addGold(player, amount)
    local inventory = getPlayerInventory(player)
    inventory.gold = (inventory.gold or 0) + amount
    
    -- SYNC WITH MONEY VALUE
    if player:FindFirstChild("Money") then
        player.Money.Value = inventory.gold
    end
    
    savePlayerInventory(player, inventory)
    return inventory.gold
end

local function spendGold(player, amount)
    local inventory = getPlayerInventory(player)
    if (inventory.gold or 0) >= amount then
        inventory.gold = inventory.gold - amount
        
        -- SYNC WITH MONEY VALUE
        if player:FindFirstChild("Money") then
            player.Money.Value = inventory.gold
        end
        
        savePlayerInventory(player, inventory)
        return true
    end
    return false
end

local function giveGun(player)
    local inventory = getPlayerInventory(player)
    inventory.hasGun = true
    savePlayerInventory(player, inventory)
end

-- ============================================
-- COMBAT FUNCTIONS
-- ============================================
local function damageEnemy(enemy, damage)
    if enemy:FindFirstChild("Humanoid") then
        enemy.Humanoid:TakeDamage(damage)
        return true
    end
    return false
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

local function fireWeapon(player, weapon, target)
    if not useAmmo(player, CONFIG.WEAPON_AMMO_PER_SHOT) then
        return {success = false, message = "Out of ammo!"}
    end
    
    if damageEnemy(target, CONFIG.WEAPON_DAMAGE) then
        return {success = true, damage = CONFIG.WEAPON_DAMAGE}
    end
    return {success = false, message = "Target not found"}
end

local function createEnemy(position, enemyType)
    local enemy = Instance.new("Part")
    enemy.Name = enemyType
    enemy.Shape = Enum.PartType.Block
    enemy.Size = Vector3.new(2, 3, 2)
    enemy.Position = position
    enemy.CanCollide = true
    enemy.Parent = workspace
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = enemy
    humanoid.MaxHealth = CONFIG.ENEMY_HEALTH
    humanoid.Health = CONFIG.ENEMY_HEALTH
    
    humanoid.Died:Connect(function()
        local nearestPlayer = findNearestPlayer(position)
        if nearestPlayer then
            addGold(nearestPlayer, CONFIG.ENEMY_LOOT_GOLD)
            print("✓ " .. nearestPlayer.Name .. " defeated enemy, earned " .. CONFIG.ENEMY_LOOT_GOLD .. " gold")
        end
        wait(0.5)
        enemy:Destroy()
    end)
    
    return enemy
end

-- ============================================
-- PLAYER INITIALIZATION
-- ============================================
local function initializePlayer(player)
    -- Create Money value (your original script)
    initializeMoney(player)
    
    -- Create Personal Code (your original script)
    initializePersonalCode(player)
    
    -- Initialize inventory in DataStore
    local inventory = DEFAULT_INVENTORY
    inventory.gold = CONFIG.STARTING_MONEY
    inventory.ammo = CONFIG.STARTING_AMMO
    savePlayerInventory(player, inventory)
    
    print("✓ " .. player.Name .. " initialized with " .. CONFIG.STARTING_AMMO .. " ammo")
end

-- ============================================
-- REMOTE FUNCTIONS (Consolidated)
-- ============================================

-- INVENTORY SYSTEM
local InventoryRemote = Instance.new("RemoteFunction")
InventoryRemote.Name = "InventorySystem"
InventoryRemote.Parent = game.ReplicatedStorage

function InventoryRemote.OnServerInvoke(player, action, ...)
    if action == "GetInventory" then
        return getPlayerInventory(player)
    elseif action == "AddAmmo" then
        return addAmmo(player, select(1, ...))
    elseif action == "UseAmmo" then
        return useAmmo(player, select(1, ...))
    elseif action == "AddGold" then
        return addGold(player, select(1, ...))
    elseif action == "SpendGold" then
        return spendGold(player, select(1, ...))
    elseif action == "GiveGun" then
        giveGun(player)
        return true
    end
end

-- CODE SYSTEM
local CodeRemote = Instance.new("RemoteFunction")
CodeRemote.Name = "CodeSystem"
CodeRemote.Parent = game.ReplicatedStorage

function CodeRemote.OnServerInvoke(player, action)
    if action == "GetCode" then
        if player:FindFirstChild("PersonalCode") then
            return player.PersonalCode.Value
        end
    elseif action == "GenerateNewCode" then
        if player:FindFirstChild("PersonalCode") then
            player.PersonalCode.Value = generateCode()
            return player.PersonalCode.Value
        end
    end
    return nil
end

-- COMBAT SYSTEM
local CombatRemote = Instance.new("RemoteFunction")
CombatRemote.Name = "CombatSystem"
CombatRemote.Parent = game.ReplicatedStorage

function CombatRemote.OnServerInvoke(player, action, ...)
    if action == "FireWeapon" then
        local weapon, target = select(1, ...), select(2, ...)
        return fireWeapon(player, weapon, target)
    elseif action == "CreateEnemy" then
        local position, enemyType = select(1, ...), select(2, ...)
        return createEnemy(position, enemyType)
    end
end

-- GUN SHOP SYSTEM
local GunShopRemote = Instance.new("RemoteFunction")
GunShopRemote.Name = "GunShopSystem"
GunShopRemote.Parent = game.ReplicatedStorage

function GunShopRemote.OnServerInvoke(player, action)
    if action == "PurchaseGun" then
        local inventory = getPlayerInventory(player)
        
        if inventory.hasGun then
            return {success = false, message = "You already have a gun"}
        end
        
        if (inventory.gold or 0) < CONFIG.GUN_PRICE then
            return {success = false, message = "Not enough gold. Need: " .. CONFIG.GUN_PRICE .. " Have: " .. (inventory.gold or 0)}
        end
        
        spendGold(player, CONFIG.GUN_PRICE)
        giveGun(player)
        
        print("✓ " .. player.Name .. " purchased gun")
        return {success = true, message = "Gun purchased!"}
    elseif action == "GetGunPrice" then
        return CONFIG.GUN_PRICE
    elseif action == "GetGunInfo" then
        return {price = CONFIG.GUN_PRICE, name = "Basic Gun"}
    end
end

-- SHOP ZONE SYSTEM
local ShopZoneRemote = Instance.new("RemoteFunction")
ShopZoneRemote.Name = "ShopZoneCheck"
ShopZoneRemote.Parent = game.ReplicatedStorage

local playersInZone = {}

function ShopZoneRemote.OnServerInvoke(player, action)
    if action == "IsInZone" then
        return playersInZone[player.UserId] or false
    end
end

_G.ShopZonePlayers = playersInZone

-- ============================================
-- PLAYER EVENTS
-- ============================================
local function onPlayerAdded(player)
    print("\n🎮 " .. player.Name .. " joined the game")
    initializePlayer(player)
end

local function onPlayerRemoving(player)
    print("👋 " .. player.Name .. " left the game")
    playersInZone[player.UserId] = nil
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Initialize existing players
for _, player in pairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- ============================================
-- STARTUP MESSAGE
-- ============================================
print("\n" .. string.rep("=", 60))
print("✓ MASTER GAME INITIALIZATION COMPLETE")
print(string.rep("=", 60))
print("Systems Loaded:")
print("  ✓ Money System (Your Script)")
print("  ✓ Personal Code System (Your Script)")
print("  ✓ Inventory System (DataStore)")
print("  ✓ Combat System")
print("  ✓ Gun Shop System")
print("  ✓ Shop Zone System")
print(string.rep("=", 60))
print("Configuration:")
print("  Starting Money: " .. CONFIG.STARTING_MONEY)
print("  Starting Ammo: " .. CONFIG.STARTING_AMMO)
print("  Gun Price: " .. CONFIG.GUN_PRICE)
print("  Personal Code Length: " .. CONFIG.CODE_LENGTH .. " digits")
print(string.rep("=", 60) .. "\n")
