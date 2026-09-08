-- Gun Shop Interaction Script (Creator Store Compatible)
-- Place this script in a ClickDetector or directly in the gun shop part
-- Works with any gun shop model from creator store

local gunShopPart = script.Parent
local Players = game:GetService("Players")

-- Create or find ClickDetector
local clickDetector = gunShopPart:FindFirstChildOfClass("ClickDetector")
if not clickDetector then
    clickDetector = Instance.new("ClickDetector")
    clickDetector.Parent = gunShopPart
end

clickDetector.MaxActivationDistance = 30 -- Adjust if needed

local function onGunShopClick(player)
    -- Wait for GunShopSystem to be available
    local gunShopSystem = game.ReplicatedStorage:WaitForChild("GunShopSystem")
    
    -- Invoke server to purchase gun
    local result = gunShopSystem:InvokeServer("PurchaseGun")
    
    if result then
        print(player.Name .. " - " .. result.message)
        -- TODO: Add GUI notification here to show result to player
        -- For now, result is logged in console
    end
end

clickDetector.MouseClick:Connect(onGunShopClick)

print("Gun Shop Interaction Script loaded for: " .. gunShopPart.Name)
