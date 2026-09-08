-- Ammo Button Script
-- Place this script inside your ammo decoration part to make it functional
-- This script makes the ammo decoration clickable to purchase ammo

local Players = game:GetService("Players")
local ammoButton = script.Parent -- The ammo decoration part

local AMMO_PRICE = 50 -- Gold cost per ammo pack
local AMMO_AMOUNT = 30  -- Amount of ammo per purchase
local BUTTON_COOLDOWN = 1 -- Seconds between purchases

local purchaseCooldown = {}

-- Create clickable detector
local clickDetector = Instance.new("ClickDetector")
clickDetector.Parent = ammoButton
clickDetector.MaxActivationDistance = 20

local function purchaseAmmo(player)
    local userId = player.UserId
    
    -- Check cooldown
    if purchaseCooldown[userId] and tick() - purchaseCooldown[userId] < BUTTON_COOLDOWN then
        print(player.Name .. " tried to purchase ammo too quickly")
        return
    end
    
    purchaseCooldown[userId] = tick()
    
    -- Try to invoke inventory system
    local inventorySystem = game.ReplicatedStorage:FindFirstChild("InventorySystem")
    if not inventorySystem then
        warn("InventorySystem not found in ReplicatedStorage")
        return
    end
    
    -- Get current inventory
    local inventory = inventorySystem:InvokeClient(player, "GetInventory")
    if not inventory then
        print(player.Name .. " has no inventory")
        return
    end
    
    -- Check if player has enough gold
    if (inventory.gold or 0) < AMMO_PRICE then
        print(player.Name .. " doesn't have enough gold. Need: " .. AMMO_PRICE .. " Has: " .. (inventory.gold or 0))
        -- You can add a notification to player here
        return
    end
    
    -- Spend gold
    local spentGold = inventorySystem:InvokeClient(player, "SpendGold", AMMO_PRICE)
    if not spentGold then
        print(player.Name .. " failed to spend gold")
        return
    end
    
    -- Add ammo
    local newAmmo = inventorySystem:InvokeClient(player, "AddAmmo", AMMO_AMOUNT)
    print(player.Name .. " purchased " .. AMMO_AMOUNT .. " ammo for " .. AMMO_PRICE .. " gold. Total ammo: " .. newAmmo)
end

clickDetector.MouseClick:Connect(function(player)
    purchaseAmmo(player)
end)

print("Ammo Button Script loaded for: " .. ammoButton.Name)
