-- Parkour Controller (Client Side)
-- Handles player movement and parkour mechanics

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local JUMP_POWER = 50
local WALK_SPEED = 20
local SPRINT_SPEED = 30

local isSprintingKeyHeld = false

-- Double jump mechanic
local canDoubleJump = false
local hasJumped = false

local function setupCharacter()
    humanoid.JumpPower = JUMP_POWER
    humanoid.WalkSpeed = WALK_SPEED
end

local function onJumped()
    if not hasJumped and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
        hasJumped = true
        canDoubleJump = true
    elseif canDoubleJump and hasJumped then
        canDoubleJump = false
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
            humanoidRootPart.AssemblyLinearVelocity.X,
            JUMP_POWER,
            humanoidRootPart.AssemblyLinearVelocity.Z
        )
    end
end

local function onStateChanged(oldState, newState)
    if newState ~= Enum.HumanoidStateType.Jumping then
        hasJumped = false
    end
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Space then
        onJumped()
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        isSprintingKeyHeld = true
        humanoid.WalkSpeed = SPRINT_SPEED
    end
end

local function onInputEnded(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        isSprintingKeyHeld = false
        humanoid.WalkSpeed = WALK_SPEED
    end
end

setupCharacter()
humanoid.StateChanged:Connect(onStateChanged)
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)

print("Parkour Controller loaded")
