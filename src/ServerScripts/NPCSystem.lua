-- NPC System
-- Manages NPCs (King, Queen, Princess) and rescue mechanics

local workspace = workspace

local NPC_DATA = {
    King = {
        name = "King",
        title = "The Wise King",
        guarded = true,
        rescued = false,
        dialogue = "Thank you, brave prince/princess! The castle is saved!"
    },
    Queen = {
        name = "Queen",
        title = "The Noble Queen",
        guarded = true,
        rescued = false,
        dialogue = "Our hero has returned! You have saved us all."
    },
    Princess = {
        name = "Princess",
        title = "The Royal Princess",
        guarded = true,
        rescued = false,
        dialogue = "Brother/Sister, you did it! The creatures are defeated!"
    }
}

local function getNPCStatus(npcName)
    return NPC_DATA[npcName] or nil
end

local function rescueNPC(npcName)
    if NPC_DATA[npcName] then
        NPC_DATA[npcName].rescued = true
        NPC_DATA[npcName].guarded = false
        return true
    end
    return false
end

local function areAllNPCsRescued()
    for _, npc in pairs(NPC_DATA) do
        if not npc.rescued then
            return false
        end
    end
    return true
end

local function getNPCDialogue(npcName)
    if NPC_DATA[npcName] then
        return NPC_DATA[npcName].dialogue
    end
    return nil
end

-- RemoteFunction for NPC interactions
local RemoteFunction = Instance.new("RemoteFunction")
RemoteFunction.Name = "NPCSystem"
RemoteFunction.Parent = game.ReplicatedStorage

function RemoteFunction.OnServerInvoke(player, action, npcName)
    if action == "GetNPCStatus" then
        return getNPCStatus(npcName)
    elseif action == "RescueNPC" then
        return rescueNPC(npcName)
    elseif action == "CheckAllRescued" then
        return areAllNPCsRescued()
    elseif action == "GetDialogue" then
        return getNPCDialogue(npcName)
    end
end

print("NPC System loaded")
