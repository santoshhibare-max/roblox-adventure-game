-- Gun Controller (Client Side)
-- Handles weapon firing and aiming

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

local CombatSystem = game.ReplicatedStorage:WaitForChild("CombatSystem")
local InventorySystem = game.ReplicatedStorage:WaitForChild("InventorySystem")

local GUN_FIRE_RATE = 0.2
local lastFireTime = 0

local function createRaycast(origin, direction)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
    raycastParams.FilterDescendantsInstances = {workspace}
    
    local result = workspace:Raycast(origin, direction * 100, raycastParams)
    return result
end

local function fireGun()
    local currentTime = tick()
    if currentTime - lastFireTime < GUN_FIRE_RATE then
        return
    end
    lastFireTime = currentTime
    
    -- Check if player has gun
    local inventory = InventorySystem:InvokeServer("GetInventory")
    if not inventory or not inventory.hasGun then
        print("No gun equipped")
        return
    end
    
    -- Raycast from camera
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = camera.CFrame.LookVector
    
    local raycastResult = createRaycast(origin, direction)
    if raycastResult then
        local hit = raycastResult.Instance
        if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
            -- Hit an enemy
            CombatSystem:InvokeServer("FireWeapon", "Gun", hit.Parent)
        end
    end
end

local function onMouseClick()
    fireGun()
end

mouse.Button1Down:Connect(onMouseClick)

print("Gun Controller loaded")
