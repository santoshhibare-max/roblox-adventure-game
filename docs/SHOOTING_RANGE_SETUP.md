# SHOOTING RANGE SETUP

## 🎯 Shooting Range System

**Features:**
- 7 targets in the range
- +2 gold coins per target hit
- Targets respawn after 3 seconds
- Money counter in bottom left corner
- Infinite practice

---

## Setup Instructions:

### Step 1: Create 7 Target Parts
In your Shooting Range area:
1. Insert → **Part** (7 times)
2. Name each: `Target1`, `Target2`, ... `Target7`
3. Set properties:
   - Shape: Cylinder or Cube
   - Size: 2x2x1
   - Color: Red (255, 0, 0)
   - CanCollide: true
4. Position them spread out in your range

### Step 2: Add Target Script to EACH Target
1. Select **Target1**
2. Insert → **Script**
3. Copy code from `ShootingRangeTarget.lua`
4. Paste it
5. **Repeat for all 7 targets**

### Step 3: Add Money Display GUI
1. Go to **StarterPlayer** → **StarterPlayerScripts**
2. Insert → **LocalScript**
3. Copy code from `MoneyDisplayGui.lua`
4. Paste it
5. Done! ✅

---

## How It Works:

1. 🎯 Player shoots target
2. 💰 Target dies → +2 gold
3. 📊 Money counter updates (bottom left)
4. ⏱️ 3 seconds pass
5. 🔄 Target respawns
6. Repeat!

---

## Configuration:

**Change gold per hit:**
In `ShootingRangeTarget.lua`, line 7:
```lua
local GOLD_PER_HIT = 2  -- Change this number
```

**Change respawn time:**
Line 8:
```lua
local RESPAWN_TIME = 3  -- Seconds before respawn
```

**Change max health:**
Line 9:
```lua
local MAX_HEALTH = 30  -- Health per target
```

---

## Money Display GUI:

**Location:** Bottom left corner
**Updates:** Every 0.5 seconds
**Shows:** Current gold amount
**Colors:** Gold/Yellow text on dark background

---

## Testing:

1. Join game
2. Go to Shooting Range
3. Shoot targets (depends on your weapon system)
4. See gold increase in bottom left
5. Target dies & respawns after 3 seconds
6. Infinite practice!

---

## How to Shoot Targets:

If you have a gun weapon system:
- Fire weapon at targets
- Targets take damage
- Targets die → +2 gold
- Respawn

If you need a simple shooting mechanic:
- You can use ClickDetector on targets
- Or create projectiles that hit targets

---

## Debug Output:

You should see in console:
```
🎯 Target script loaded for: Target1
🎯 Target script loaded for: Target2
...
💰 Money Display GUI loaded
🎯 PlayerName shot target! +2 gold
🔄 Target respawned!
```

If you see this = Working! ✅

---

## Next Steps:

After this, you can:
1. Add the combat zone at the end
2. Add enemy AI
3. Make bosses
4. Add leaderboards

Let me know when you're ready! 🚀
