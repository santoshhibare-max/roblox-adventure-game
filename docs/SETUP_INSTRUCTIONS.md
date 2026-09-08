# Setup Instructions

## Prerequisites
- Roblox Studio
- Lua knowledge (basic)
- Understanding of Roblox architecture

## Initial Studio Setup

### 1. Create Base Workspace
- Create a new Roblox place in Studio
- Keep default terrain or clear it
- Create a concrete baseplate for spawn area

### 2. Add Server Scripts

In **ServerScriptService**, add these scripts from `src/ServerScripts/`:
- `SpawnSystem.lua`
- `CodeGenerationSystem.lua`
- `LockSystem.lua`
- `InventorySystem.lua`
- `NPCSystem.lua`
- `CombatSystem.lua`

### 3. Add LocalScripts

In **StarterPlayer/StarterCharacterScripts**:
- `ParkourController.lua`

In **StarterPlayer/StarterPlayerScripts**:
- `GunController.lua`

### 4. Create Game Areas

#### Spawn Area
- Create platform named "SpawnLocation"
- Position at coordinates (0, 10, 0)
- Size: 50x1x50

#### Parkour Section
- Design parkour course with platforms
- Add tricky jumps and obstacles
- At end, add part that triggers code generation

#### Locked Door
- Create part named "LockedDoor"
- Place between parkour and key area
- Script to check unlock status on touch

#### Key Location
- Create key object
- Place in accessible area after unlock
- Script to add to inventory on touch

#### Portal Area
- Create portal visual effect
- Teleports player to combat zone
- Requires key in inventory

#### Combat Zone (Parallel World)
- Dark/parallel themed area
- Spawn multiple enemies
- Place NPC guards with bosses
- Add ammo/supply crates

#### NPC Locations
- King: Throne room area
- Queen: Castle chamber
- Princess: Tower area
- Guard each with parallel creatures

### 5. Weapons & Upgrades

#### Gun Pickup
- Create part in combat zone
- Script to give gun on touch
- Hides after pickup

#### Ammo Crates
- Scattered throughout combat zone
- Add 50 ammo on pickup
- Respawn or single-use

#### Upgrade Station
- NPC vendor in base area
- Sell upgrades for gold
- Example: Increased damage, faster fire rate

## Testing Checklist

- [ ] Players spawn correctly
- [ ] Parkour course is completable
- [ ] Code generates and displays to player
- [ ] Door unlocks with correct code
- [ ] Locked door blocks incorrect code
- [ ] Key is obtainable
- [ ] Portal teleports player
- [ ] Enemies spawn and attack
- [ ] Gun fires and kills enemies
- [ ] Ammo decreases on fire
- [ ] Gold drops from defeated enemies
- [ ] All NPCs can be rescued
- [ ] Win condition triggers when all NPCs rescued

## Common Issues

### Players fall through world
- Ensure baseplate collision is enabled
- Check CanCollide property

### Code not generating
- Verify DataStore is enabled in game settings
- Check ServerScriptService has all scripts

### Gun not firing
- Ensure LocalScript is in StarterPlayer
- Check that enemies have Humanoid
- Verify raycast parameters

### NPCs not rescuing
- Confirm NPC models have HumanoidRootPart
- Verify NPC system script is running
- Check creature damage values

## Next Steps

1. Build all physical areas in Studio
2. Test each system individually
3. Add visual effects and sounds
4. Polish UI and HUDs
5. Balance difficulty
6. Add particle effects for combat
7. Implement leaderboards
