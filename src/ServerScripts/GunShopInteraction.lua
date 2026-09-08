-- Gun Shop Interaction Script
-- Place this in a part in your gun shop to make it purchasable

local gunShopPart = script.Parent

local clickDetector = Instance.new("ClickDetector")
clickDetector.Parent = gunShopPart
clickDetector.MaxActivationDistance = 20

local function onGunShopClick(player)
    local gunShopSystem = game.ReplicatedStorage:WaitForChild("GunShopSystem")
    local result = gunShopSystem:InvokeServer("PurchaseGun")
    
    print(player.Name .. ": " .. result.message)
    -- You can add GUI notification here to show result to player
end

clickDetector.MouseClick:Connect(onGunShopClick)

print("Gun Shop Interaction Script loaded for: " .. gunShopPart.Name)
