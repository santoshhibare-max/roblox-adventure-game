# Shop System Setup

## What You're Getting:

### 🎪 Circular Shop Zone
- Players enter a circular area in your world
- Right-click to open shop GUI
- GUI shows "Buy Ammo" and "Buy Gun" options

---

## Setup Instructions:

### Step 1: Create Shop Zone in Studio
1. In Workspace, create a **Part** (size doesn't matter, will be invisible)
2. Name it: `ShopZone`
3. Make it **CanCollide = false**
4. Make it **Transparency = 1** (invisible)
5. Position it where you want the shop
6. Size it to about **50x50x50** (adjustable)

### Step 2: Add Server Script
1. Select the `ShopZone` part
2. Insert → **Script**
3. Copy code from `ShopZoneScript.lua`
4. Paste it in

### Step 3: Add LocalScript
1. In **StarterPlayer** → **StarterPlayerScripts**
2. Insert → **LocalScript**
3. Copy code from `ShopGuiScript.lua`
4. Paste it in

---

## How It Works:

1. ✅ Player walks into circular zone
2. ✅ Script detects player is in zone
3. ✅ Player right-clicks mouse
4. ✅ Shop GUI window opens with:
   - **🔫 Buy Ammo** (50 gold → +30 ammo)
   - **🎯 Buy Gun** (200 gold → 1 gun)
   - **X** button to close

---

## Customization:

### Change Shop Prices
Edit in `ShopGuiScript.lua`:
- Line 67: Ammo price (currently 50)
- Line 68: Ammo amount (currently 30)
- Line 81: Gun price (currently 200)

### Change Zone Size
Edit the `ShopZone` part size in Studio to make it bigger/smaller

### Change Shop Colors
Edit RGB values in `ShopGuiScript.lua`:
- Line 22: Main frame color
- Line 30: Title color
- Line 43: Ammo button color
- Line 56: Gun button color

### Change GUI Position
Edit line 13 in `ShopGuiScript.lua`:
```lua
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
-- Change -200 and -150 to adjust position
```

---

## Testing:

1. Join game
2. Walk to the `ShopZone` part
3. **Right-click** mouse
4. Shop GUI should pop up! 🎉
5. Click buttons to buy items
6. Click X to close

---

## Features:

✅ Beautiful GUI with rounded corners
✅ Right-click to open/close
✅ Buy ammo with gold
✅ Buy gun with gold  
✅ Button feedback (color change on success/fail)
✅ Works with existing inventory system
✅ Can only buy gun if you don't have one
✅ Shows gold requirements
