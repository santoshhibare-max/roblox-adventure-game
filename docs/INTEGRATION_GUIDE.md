# Integration Guide for Your Existing Game

## Your Current Setup
✅ Parkour course
✅ Cozy house spawn area
✅ Gun shop with ammo decoration

## New Scripts to Add

### 1. Ammo Button Script
**File**: `src/ServerScripts/AmmoButtonScript.lua`

**How to use**:
1. Select your ammo decoration part in Studio
2. Insert a new **Script** inside it (not LocalScript)
3. Copy the code from `AmmoButtonScript.lua`
4. Configure:
   - `AMMO_PRICE = 50` (gold cost)
   - `AMMO_AMOUNT = 30` (ammo per purchase)
   - `BUTTON_COOLDOWN = 1` (seconds between purchases)

**Features**:
- Click to purchase ammo
- Costs gold from player inventory
- Cooldown between purchases
- Automatic gold deduction

---

### 2. Gun Shop Interaction Script
**Files**: 
- `src/ServerScripts/GunShopSystem.lua` (in ServerScriptService)
- `src/ServerScripts/GunShopInteraction.lua` (in gun shop part)

**How to use**:
1. Add `GunShopSystem.lua` to **ServerScriptService**
2. Select your gun shop part in Studio
3. Insert a new **Script** inside it
4. Copy code from `GunShopInteraction.lua`
5. Configure:
   - Edit `GUN_SHOP_CONFIG.Gun.price` in GunShopSystem.lua

**Features**:
- Click to buy gun
- Checks if player has enough gold
- Prevents buying multiple guns
- Shows purchase messages

---

### 3. Parkour Completion Detector
**File**: `src/ServerScripts/ParkourCompletionDetector.lua`

**How to use**:
1. Create a new part at the end of your parkour course
2. Name it something like "ParkourEnd"
3. Insert a new **Script** inside it
4. Copy code from `ParkourCompletionDetector.lua`
5. Make it non-visible/transparent if desired

**Features**:
- Detects when player completes parkour
- Automatically generates unlock code
- Gives 150 gold bonus
- Only triggers once per player

---

### 4. Door Unlock System
**File**: `src/ServerScripts/DoorUnlockSystem.lua`

**How to use**:
1. Select your locked door part
2. Insert a new **Script** inside it
3. Copy code from `DoorUnlockSystem.lua`

**Features**:
- Click to unlock door
- Door becomes transparent and walkable
- Auto-closes after 10 seconds
- Tracks which players unlocked it

---

### 5. Cozy House Setup
**File**: `src/ServerScripts/CozyHouseSetup.lua`

**How to use**:
1. Add to **ServerScriptService**
2. Initializes player spawn in house

---

## Complete Setup Checklist

### In Studio
- [ ] Create `SpawnLocation` part in cozy house
- [ ] Place ammo decoration → Add AmmoButtonScript.lua
- [ ] Create gun shop part → Add GunShopInteraction.lua
- [ ] Create part at parkour end → Add ParkourCompletionDetector.lua
- [ ] Select locked door → Add DoorUnlockSystem.lua

### In ServerScriptService
- [ ] SpawnSystem.lua
- [ ] CodeGenerationSystem.lua
- [ ] LockSystem.lua
- [ ] InventorySystem.lua
- [ ] NPCSystem.lua
- [ ] CombatSystem.lua
- [ ] GunShopSystem.lua
- [ ] ParkourCompletionDetector.lua
- [ ] CozyHouseSetup.lua

### In StarterPlayer/StarterCharacterScripts
- [ ] ParkourController.lua

### In StarterPlayer/StarterPlayerScripts
- [ ] GunController.lua

---

## Testing Your Integration

1. **Test Spawn**:
   - Join game → Should spawn in cozy house
   - Check if you have starting gold and ammo

2. **Test Parkour**:
   - Complete parkour course
   - Should receive unlock code and 150 gold

3. **Test Ammo Button**:
   - Click ammo decoration
   - Should deduct gold and add ammo
   - Check inventory in console

4. **Test Gun Shop**:
   - Click gun shop part
   - Buy gun with 200 gold
   - Verify gun is in inventory

5. **Test Door**:
   - Click locked door
   - Should open/become transparent
   - Should close after 10 seconds

6. **Test Combat**:
   - Spawn enemies
   - Equip gun and ammo
   - Fire at enemies
   - Check ammo decreases

---

## Common Issues & Fixes

### "InventorySystem not found"
- Make sure `InventorySystem.lua` is in ServerScriptService
- Wait a moment for server scripts to load

### Ammo button doesn't work
- Check that the part has a Script (not LocalScript)
- Verify ClickDetector is created
- Check console for errors

### Door won't open
- Make sure door part has CanCollide = true initially
- Check that LockSystem.lua is loaded

### Code not generating
- Verify DataStore is enabled in game settings
- Check that CodeGenerationSystem.lua is running
- Look for errors in Output console

---

## Next Steps

1. Add particle effects when:
   - Code is generated
   - Door opens
   - Enemy dies
   - Ammo is purchased

2. Create a GUI to:
   - Show unlock code to player
   - Display inventory (ammo, gold)
   - Show purchase confirmations
   - Display door unlock prompts

3. Add sound effects:
   - Parkour completion
   - Door unlock
   - Gun firing
   - Enemy hit

4. Design the portal and parallel world area
5. Create enemy spawning logic
6. Add NPC dialogue system
