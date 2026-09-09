-- Shooting Range Money Display GUI
-- Place this script in StarterPlayer > StarterPlayerScripts
-- Shows money counter in bottom left corner

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Money Frame (Bottom Left)
local moneyFrame = Instance.new("Frame")
moneyFrame.Name = "MoneyFrame"
moneyFrame.Size = UDim2.new(0, 250, 0, 80)
moneyFrame.Position = UDim2.new(0, 20, 1, -100)  -- Bottom left
moneyFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
moneyFrame.BorderSizePixel = 0
moneyFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = moneyFrame

-- Money Icon/Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(1, 0, 0, 40)
moneyLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
moneyLabel.TextColor3 = Color3.fromRGB(255, 215, 0)  -- Gold color
moneyLabel.TextSize = 24
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "💰 MONEY"
moneyLabel.BorderSizePixel = 0
moneyLabel.Parent = moneyFrame

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 10)
labelCorner.Parent = moneyLabel

-- Money Amount Display
local moneyAmount = Instance.new("TextLabel")
moneyAmount.Name = "MoneyAmount"
moneyAmount.Size = UDim2.new(1, 0, 0, 40)
moneyAmount.Position = UDim2.new(0, 0, 0, 40)
moneyAmount.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
moneyAmount.TextColor3 = Color3.fromRGB(255, 255, 255)
moneyAmount.TextSize = 28
moneyAmount.Font = Enum.Font.GothamBold
moneyAmount.Text = "500"
moneyAmount.BorderSizePixel = 0
moneyAmount.Parent = moneyFrame

local amountCorner = Instance.new("UICorner")
amountCorner.CornerRadius = UDim.new(0, 10)
amountCorner.Parent = moneyAmount

-- Update money display
local function updateMoneyDisplay()
    local inventoryRemote = game.ReplicatedStorage:WaitForChild("InventorySystem")
    
    while true do
        -- Get current gold
        local inventory = inventoryRemote:InvokeServer("GetInventory")
        if inventory and inventory.gold then
            moneyAmount.Text = tostring(inventory.gold)
        end
        
        -- Also check player Money value
        if player:FindFirstChild("Money") then
            moneyAmount.Text = tostring(player.Money.Value)
        end
        
        wait(0.5)  -- Update every 0.5 seconds
    end
end

-- Start update loop
spawn(function()
    updateMoneyDisplay()
end)

print("💰 Money Display GUI loaded")
