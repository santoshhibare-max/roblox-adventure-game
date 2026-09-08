-- Door Unlock System
-- Place this script in your locked door part
-- Players can click to enter their unlock code

local Players = game:GetService("Players")
local doorPart = script.Parent

local clickDetector = Instance.new("ClickDetector")
clickDetector.Parent = doorPart
clickDetector.MaxActivationDistance = 20

local unlockedDoors = {}

local function openDoor()
    -- You can add a visual door opening animation here
    -- For now, we'll just make it transparent and non-solid
    doorPart.Transparency = 0.5
    doorPart.CanCollide = false
    
    -- Close door after 10 seconds
    wait(10)
    doorPart.Transparency = 0
    doorPart.CanCollide = true
end

local function onDoorClick(player)
    local userId = player.UserId
    
    -- Check if already unlocked for this player
    if unlockedDoors[userId] then
        print(player.Name .. " already unlocked this door")
        openDoor()
        return
    end
    
    -- Show GUI prompt for code input (you'll need to create a GUI for this)
    -- For now, we'll just try to get their code
    local codeSystem = game.ReplicatedStorage:FindFirstChild("CodeSystem")
    if codeSystem then
        local playerCode = codeSystem:InvokeServer("GetCode", player)
        
        -- Verify code
        local lockSystem = game.ReplicatedStorage:FindFirstChild("LockSystem")
        if lockSystem then
            local result = lockSystem:InvokeServer("Unlock", playerCode)
            if result.success then
                unlockedDoors[userId] = true
                print(player.Name .. " unlocked the door!")
                openDoor()
            else
                print(player.Name .. " entered wrong code")
            end
        end
    end
end

clickDetector.MouseClick:Connect(onDoorClick)

print("Door Unlock System loaded for: " .. doorPart.Name)
