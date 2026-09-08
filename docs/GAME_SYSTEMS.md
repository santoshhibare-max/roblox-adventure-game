# Game Systems Documentation

## Overview
This document outlines all major game systems and their interactions.

## 1. Spawn System
**File**: `src/ServerScripts/SpawnSystem.lua`

- Teleports players to spawn location on join
- Handles respawning when player dies
- Uses concrete baseplate as reference point

## 2. Code Generation System
**File**: `src/ServerScripts/CodeGenerationSystem.lua`

- Generates unique 6-character alphanumeric codes per player
- Codes are awarded after completing parkour section
- Stored in DataStore for persistence
- Used to unlock restricted areas

### Code Format
- Length: 6 characters
- Characters: A-Z and 0-9
- Example: `ABC123`

## 3. Lock/Unlock System
**File**: `src/ServerScripts/LockSystem.lua`

- Verifies player codes against stored codes
- Unlocks doors/areas when correct code is entered
- Tracks which players have unlocked areas
- Grants access to key and portal

## 4. Inventory System
**File**: `src/ServerScripts/InventorySystem.lua`

**Tracks**:
- Ammo count
- Gold/currency
- Gun possession
- Upgrades

**Operations**:
- Add/use ammo
- Add/spend gold
- Give gun to player

## 5. NPC System
**File**: `src/ServerScripts/NPCSystem.lua`

**NPCs**:
- King (guarded by creatures)
- Queen (guarded by creatures)
- Princess (guarded by creatures)

**Mechanics**:
- Track rescue status
- Display dialogue when rescued
- Win condition: All NPCs rescued

## 6. Combat System
**File**: `src/ServerScripts/CombatSystem.lua`

**Features**:
- Weapon configurations (Gun with 25 damage)
- Enemy AI (Parallel Creatures)
- Ammo consumption on fire
- Enemy loot drops (gold)
- Health tracking

**Enemy Types**:
- ParallelCreature: 50 HP, 10 damage, drops 10 gold

## 7. Parkour Controller
**File**: `src/LocalScripts/ParkourController.lua`

**Features**:
- Normal jump: JumpPower 50
- Sprint: LeftShift increases speed to 30
- Double jump mechanic
- Smooth movement controls

## 8. Gun Controller
**File**: `src/LocalScripts/GunController.lua`

**Features**:
- Mouse click to fire
- Raycast-based hit detection
- Fire rate: 0.2 seconds
- Requires gun in inventory
- Requires ammo

## Game Flow

```
1. Player Spawns
   ↓
2. Player Navigates Parkour Section
   ↓
3. Player Receives Random Code
   ↓
4. Player Unlocks Door with Code
   ↓
5. Player Finds Key to Portal
   ↓
6. Player Gets Upgraded
   ↓
7. Player Buys Gun & Ammo
   ↓
8. Player Enters Portal (Parallel World)
   ↓
9. Player Battles Creatures
   ↓
10. Player Rescues King/Queen/Princess
   ↓
11. Game Won!
```

## DataStores Used

- `PlayerUnlockCodes`: Stores unlock codes
- `PlayerInventory`: Stores player inventory state

## Remote Functions

- `CodeSystem`: Generate and retrieve codes
- `LockSystem`: Verify codes and check unlock status
- `InventorySystem`: Manage inventory operations
- `NPCSystem`: NPC interactions
- `CombatSystem`: Combat operations

## Configuration

All game constants are defined in their respective system files.
Easy to tweak:
- Damage values
- Fire rates
- Speed values
- Code length
- Starting inventory
