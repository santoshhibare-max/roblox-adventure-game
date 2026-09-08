-- Player Setup Module
-- Initializes player properties and systems

local PlayerSetup = {}

function PlayerSetup.setupNewPlayer(player)
    print("Setting up player: " .. player.Name)
    
    -- Initialize inventory
    local InventorySystem = game.ReplicatedStorage:WaitForChild("InventorySystem")
    local inventory = InventorySystem:InvokeClient(player, "GetInventory")
    
    -- Initialize unlock code
    local CodeSystem = game.ReplicatedStorage:WaitForChild("CodeSystem")
    CodeSystem:InvokeServer("GenerateCode")
    
    -- Add any startup items
    InventorySystem:InvokeServer("AddGold", 100) -- Starting gold
    InventorySystem:InvokeServer("AddAmmo", 30)   -- Starting ammo
end

function PlayerSetup.setupCharacter(character)
    print("Setting up character: " .. character.Name)
    -- Add any character-specific initialization
end

return PlayerSetup
