-- Gun Shop System
-- Manage gun purchases and sales
-- Place server script in a part representing the gun shop

local Players = game:GetService("Players")

local GUN_SHOP_CONFIG = {
    Gun = {
        price = 200,
        name = "Basic Gun",
        description = "A reliable gun for combat"
    }
}

local function purchaseGun(player)
    local gunConfig = GUN_SHOP_CONFIG.Gun
    
    -- Get inventory
    local inventorySystem = game.ReplicatedStorage:FindFirstChild("InventorySystem")
    if not inventorySystem then
        return {success = false, message = "Inventory system not found"}
    end
    
    local inventory = inventorySystem:InvokeClient(player, "GetInventory")
    if not inventory then
        return {success = false, message = "Could not get inventory"}
    end
    
    -- Check if already has gun
    if inventory.hasGun then
        return {success = false, message = "You already have a gun"}
    end
    
    -- Check gold
    if (inventory.gold or 0) < gunConfig.price then
        return {success = false, message = "Not enough gold. Need: " .. gunConfig.price .. " Have: " .. (inventory.gold or 0)}
    end
    
    -- Spend gold and give gun
    inventorySystem:InvokeClient(player, "SpendGold", gunConfig.price)
    inventorySystem:InvokeClient(player, "GiveGun")
    
    print(player.Name .. " purchased a gun for " .. gunConfig.price .. " gold")
    return {success = true, message = "Gun purchased! You now have " .. gunConfig.name}
end

-- Create RemoteFunction for gun shop
local gunShopRemote = Instance.new("RemoteFunction")
gunShopRemote.Name = "GunShopSystem"
gunShopRemote.Parent = game.ReplicatedStorage

function gunShopRemote.OnServerInvoke(player, action, ...)
    if action == "PurchaseGun" then
        return purchaseGun(player)
    elseif action == "GetGunPrice" then
        return GUN_SHOP_CONFIG.Gun.price
    elseif action == "GetGunInfo" then
        return GUN_SHOP_CONFIG.Gun
    end
end

print("Gun Shop System loaded")
