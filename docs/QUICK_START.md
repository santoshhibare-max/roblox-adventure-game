# Quick Start Guide

## To Get Started Immediately:

### 1. Add PlayerInitialization Script
- Add `PlayerInitialization.lua` to **ServerScriptService**
- This gives every player **500 gold** and **30 ammo** when they join
- You can edit the amounts at the top of the script

### 2. Current Setup
You now have:
- ✅ Cozy house spawn
- ✅ Parkour course
- ✅ Gun shop (clickable)
- ✅ Ammo button (clickable)
- ✅ Starting gold/ammo

### 3. Test the Game
1. Join the game
2. Check console (View → Output)
3. You should see: `Your Name received 500 starting gold. Total: 500`
4. Click gun shop → Buy gun for 200 gold
5. Click ammo button → Buy ammo for 50 gold

### 4. Getting More Gold
Currently, you get gold by:
- **Starting amount**: 500 gold
- **Completing parkour**: 150 gold bonus
- **Defeating enemies**: 10 gold per creature

### 5. Adjust Starting Amount
Edit line 5 in `PlayerInitialization.lua`:
```lua
local STARTING_GOLD = 500  -- Change this number
```

---

## What's Working Now:
- ✅ Player spawn in house
- ✅ Starting inventory (gold + ammo)
- ✅ Ammo button purchases
- ✅ Gun shop purchases
- ✅ Parkour completion rewards
- ✅ Door unlock system

## Next Steps:
- [ ] Add portal to combat zone
- [ ] Spawn enemies in combat zone
- [ ] Add NPC rescue mechanics
- [ ] Create win condition
