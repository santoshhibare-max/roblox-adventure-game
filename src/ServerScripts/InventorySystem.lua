-- Inventory System
-- Manages player inventory, weapons, ammo, and upgrades

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local inventoryStore = DataStoreService:GetDataStore("PlayerInventory")

local DEFAULT_INVENTORY = {
    ammo = 0,
    gold = 0,
    hasGun = false,
    upgrades = {}
}

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
    local success, err = pcall(function()
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
    savePlayerInventory(player, inventory)
    return inventory.gold
end

local function spendGold(player, amount)
    local inventory = getPlayerInventory(player)
    if (inventory.gold or 0) >= amount then
        inventory.gold = inventory.gold - amount
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

-- RemoteFunction for inventory operations
local RemoteFunction = Instance.new("RemoteFunction")
RemoteFunction.Name = "InventorySystem"
RemoteFunction.Parent = game.ReplicatedStorage

function RemoteFunction.OnServerInvoke(player, action, ...)
    if action == "GetInventory" then
        return getPlayerInventory(player)
    elseif action == "AddAmmo" then
        local amount = select(1, ...)
        return addAmmo(player, amount)
    elseif action == "UseAmmo" then
        local amount = select(1, ...)
        return useAmmo(player, amount)
    elseif action == "AddGold" then
        local amount = select(1, ...)
        return addGold(player, amount)
    elseif action == "SpendGold" then
        local amount = select(1, ...)
        return spendGold(player, amount)
    elseif action == "GiveGun" then
        giveGun(player)
        return true
    end
end

print("Inventory System loaded")
