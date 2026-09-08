-- Shop GUI LocalScript
-- Place this in StarterPlayer > StarterPlayerScripts
-- Handles shop GUI and purchases

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local shopGui = nil
local shopVisible = false

-- Create Shop GUI
local function createShopGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShopGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "⚔️ SHOP"
    titleLabel.BorderSizePixel = 0
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Buy Ammo Button
    local buyAmmoButton = Instance.new("TextButton")
    buyAmmoButton.Name = "BuyAmmoButton"
    buyAmmoButton.Size = UDim2.new(0.9, 0, 0, 80)
    buyAmmoButton.Position = UDim2.new(0.05, 0, 0.2, 0)
    buyAmmoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    buyAmmoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyAmmoButton.TextSize = 18
    buyAmmoButton.Font = Enum.Font.Gotham
    buyAmmoButton.Text = "🔫 Buy Ammo (50 Gold)\n+30 Ammo"
    buyAmmoButton.BorderSizePixel = 0
    buyAmmoButton.Parent = mainFrame
    
    local ammoCorner = Instance.new("UICorner")
    ammoCorner.CornerRadius = UDim.new(0, 8)
    ammoCorner.Parent = buyAmmoButton
    
    -- Buy Gun Button
    local buyGunButton = Instance.new("TextButton")
    buyGunButton.Name = "BuyGunButton"
    buyGunButton.Size = UDim2.new(0.9, 0, 0, 80)
    buyGunButton.Position = UDim2.new(0.05, 0, 0.55, 0)
    buyGunButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
    buyGunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    buyGunButton.TextSize = 18
    buyGunButton.Font = Enum.Font.Gotham
    buyGunButton.Text = "🎯 Buy Gun (200 Gold)\n1 Gun"
    buyGunButton.BorderSizePixel = 0
    buyGunButton.Parent = mainFrame
    
    local gunCorner = Instance.new("UICorner")
    gunCorner.CornerRadius = UDim.new(0, 8)
    gunCorner.Parent = buyGunButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0.15, 0, 0.15, 0)
    closeButton.Position = UDim2.new(0.85, 0, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Handle button clicks
    local inventorySystem = game.ReplicatedStorage:WaitForChild("InventorySystem")
    local gunShopSystem = game.ReplicatedStorage:WaitForChild("GunShopSystem")
    
    buyAmmoButton.MouseButton1Click:Connect(function()
        print("Buying ammo...")
        local result = inventorySystem:InvokeServer("GetInventory")
        if result and (result.gold or 0) >= 50 then
            inventorySystem:InvokeServer("SpendGold", 50)
            inventorySystem:InvokeServer("AddAmmo", 30)
            print("Ammo purchased! New ammo: " .. (result.ammo + 30))
            buyAmmoButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
            wait(0.5)
            buyAmmoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        else
            print("Not enough gold!")
            buyAmmoButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            wait(0.5)
            buyAmmoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        end
    end)
    
    buyGunButton.MouseButton1Click:Connect(function()
        print("Buying gun...")
        local result = gunShopSystem:InvokeServer("PurchaseGun")
        if result.success then
            print("Gun purchased!")
            buyGunButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
            wait(0.5)
            buyGunButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
        else
            print("Purchase failed: " .. result.message)
            buyGunButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            wait(0.5)
            buyGunButton.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        shopVisible = false
    end)
    
    return screenGui
end

-- Handle right click to open shop
local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        local shozoneCheck = game.ReplicatedStorage:FindFirstChild("ShopZoneCheck")
        if shopZoneCheck then
            local inZone = shopZoneCheck:InvokeServer("IsInZone")
            if inZone and not shopVisible then
                shopVisible = true
                createShopGui()
            end
        end
    end
end

UserInputService.InputBegan:Connect(onInputBegan)

print("Shop GUI LocalScript loaded")
