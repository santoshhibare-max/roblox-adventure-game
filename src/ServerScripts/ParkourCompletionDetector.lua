-- Parkour Completion Detector
-- Place a part at the end of your parkour course
-- When player touches it, they receive an unlock code

local Players = game:GetService("Players")
local parkourEndPart = script.Parent -- The part at end of parkour

local playersCompletedParkour = {}

local function onParkourTouched(hit)
    local humanoid = hit.Parent:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local player = Players:FindFirstChild(hit.Parent.Name)
    if not player then return end
    
    local userId = player.UserId
    
    -- Check if already completed
    if playersCompletedParkour[userId] then
        return
    end
    
    playersCompletedParkour[userId] = true
    
    -- Generate code for player
    local codeSystem = game.ReplicatedStorage:FindFirstChild("CodeSystem")
    if codeSystem then
        local code = codeSystem:InvokeServer("GenerateCode")
        print(player.Name .. " completed parkour! Code: " .. code)
        
        -- Add bonus gold for completing parkour
        local inventorySystem = game.ReplicatedStorage:FindFirstChild("InventorySystem")
        if inventorySystem then
            inventorySystem:InvokeServer("AddGold", 150)
            print(player.Name .. " received 150 gold for completing parkour")
        end
    end
end

parkourEndPart.Touched:Connect(onParkourTouched)

print("Parkour Completion Detector loaded for: " .. parkourEndPart.Name)
