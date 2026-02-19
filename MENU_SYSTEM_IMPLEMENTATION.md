# Menu System Implementation Summary

## Overview
Complete main menu and campaign system has been implemented for the heist game.

## What Was Implemented

### 1. Campaign Progress System
**File:** `scripts/scr_campaign_progress/scr_campaign_progress.gml`
- `get_campaign_progress()` - Returns current campaign progress
- `load_campaign_progress()` - Loads progress from JSON file
- `save_campaign_progress()` - Saves progress to JSON file
- `set_level_completed(level_num)` - Marks a level as completed
- `is_level_unlocked(level_num)` - Checks if a level is accessible
- `reset_campaign_progress()` - Debug function to reset progress

Progress is saved to: `game_save_id + "campaign/progress.json"`

### 2. Campaign Level Metadata
**File:** `scripts/scr_campaign_levels/scr_campaign_levels.gml`
- Defines 5 campaign levels with titles, descriptions, and objectives
- `get_campaign_levels()` - Returns all level definitions
- `get_campaign_level_by_num(level_num)` - Returns specific level data
- `get_campaign_level_count()` - Returns total number of levels

### 3. Campaign Level Loader
**File:** `scripts/scr_load_campaign_level/scr_load_campaign_level.gml`
- Loads campaign levels from `working_directory + "datafiles/campaign/"`
- Similar to regular level loader but uses campaign directory
- Automatically resets goal counters and game state

### 4. Main Menu
**Files:**
- `objects/obj_menu/Create_0.gml`
- `objects/obj_menu/Step_0.gml`
- `objects/obj_menu/Draw_64.gml`

Features:
- Title: "HEIST GAME"
- Campaign button → Opens campaign menu
- Level Editor button → Goes directly to fresh level editor
- Initializes global variables (global.campaign_mode, global.current_campaign_level)

### 5. Campaign Menu
**Files:**
- `objects/obj_campaign/Create_0.gml`
- `objects/obj_campaign/Step_0.gml`
- `objects/obj_campaign/Draw_64.gml`

Features:
- LEFT SIDE: Level slots showing level number, title, lock status, completion status
- RIGHT SIDE: Selected level details (title, description, objectives)
- BOTTOM: Play Mission button (only enabled for unlocked levels) and Back button
- Linear progression (Level 1 always unlocked, Level N unlocks after completing Level N-1)
- Visual indicators: locked levels shown as [LOCKED], completed levels have checkmark [✓]

### 6. Pause Menu
**Files:**
- `objects/obj_pause_menu/Create_0.gml`
- `objects/obj_pause_menu/Step_0.gml`
- `objects/obj_pause_menu/Draw_64.gml`

Features:
- Activated by pressing M key during play mode
- Resume button → Unpauses and closes menu
- Back to Menu button → Returns to main menu
- ESC or M key closes the pause menu
- Pauses game via obj_game_manager.game_paused

### 7. Controller Integration
**File:** `objects/obj_controller/Step_0.gml` (lines 59-65)
- Added M key handler to open pause menu during play mode

### 8. Win Screen Integration
**File:** `objects/obj_win_screen/Step_0.gml` (lines 26-47)
- "Return to Menu" button now functional
- Marks campaign level as completed when in campaign mode
- Saves campaign progress
- Returns player to main menu room

### 9. Game Room Campaign Loading
**File:** `rooms/Game/RoomCreationCode.gml`
- Checks if entering from campaign menu
- Loads appropriate campaign level
- Sets up game in play mode
- Spawns player and initializes game state

### 10. Campaign Levels Directory
**Location:** `datafiles/campaign/`
- Created directory structure for campaign level files
- Added README.txt with instructions for adding campaign levels
- Campaign levels should be named: campaign_level_1.json, campaign_level_2.json, etc.

## Global Variables
- `global.campaign_mode` - Set to true when starting a campaign level
- `global.current_campaign_level` - Stores the current campaign level number

## User Workflow

### Playing Campaign:
1. Game starts → Menu room with obj_menu
2. Click "CAMPAIGN" → Campaign menu overlay appears
3. Select a level (unlocked levels clickable)
4. Click "PLAY MISSION" → Loads campaign level in play mode
5. Complete level → Win screen
6. Click "BACK TO MENU" → Level marked complete, next level unlocked, return to menu

### Using Level Editor:
1. Game starts → Menu room
2. Click "LEVEL EDITOR" → Goes directly to Game room with fresh level
3. Build level in build mode
4. Press P to test level
5. Complete or press P to return to build mode

### Pausing During Gameplay:
1. During play mode, press M
2. Pause menu appears with Resume and Back to Menu options
3. Press M or ESC to close pause menu
4. Click "BACK TO MENU" to return to main menu

## Linear Progression System
- Level 1: Always unlocked
- Level 2: Unlocks after completing Level 1
- Level 3: Unlocks after completing Level 2
- Level 4: Unlocks after completing Level 3
- Level 5: Unlocks after completing Level 4

Completed levels show a checkmark [✓] in the campaign menu.

## Files Created/Modified

### Created:
1. scripts/scr_campaign_progress/scr_campaign_progress.gml
2. scripts/scr_campaign_levels/scr_campaign_levels.gml
3. scripts/scr_load_campaign_level/scr_load_campaign_level.gml
4. objects/obj_menu/Create_0.gml
5. objects/obj_menu/Step_0.gml
6. objects/obj_menu/Draw_64.gml
7. objects/obj_campaign/Create_0.gml
8. objects/obj_campaign/Step_0.gml
9. objects/obj_campaign/Draw_64.gml
10. objects/obj_pause_menu/Create_0.gml
11. objects/obj_pause_menu/Step_0.gml
12. objects/obj_pause_menu/Draw_64.gml
13. rooms/Game/RoomCreationCode.gml
14. datafiles/campaign/README.txt

### Modified:
1. objects/obj_campaign/obj_campaign.yy (added event list)
2. objects/obj_controller/Step_0.gml (added M key handler)
3. objects/obj_win_screen/Step_0.gml (implemented Return to Menu button)

## Next Steps (For User)
1. Create campaign levels in the level editor
2. Save them using the save/load menu
3. Copy the JSON files to datafiles/campaign/
4. Rename them to match the expected filenames (campaign_level_1.json, etc.)
5. Test the campaign progression!

## Testing Checklist
- [ ] Launch game → Main menu appears with title and 2 buttons
- [ ] Click Campaign → Campaign menu shows with 5 level slots
- [ ] Level 1 is unlocked, others are locked
- [ ] Select Level 1 → Description and objectives appear on right
- [ ] Click Play Mission → (Will show error if level file doesn't exist yet)
- [ ] Click Level Editor → Fresh level in build mode
- [ ] In play mode, press M → Pause menu appears
- [ ] Pause menu Resume button works
- [ ] Pause menu Back to Menu button returns to menu
- [ ] Win screen Return to Menu button works
- [ ] After completing Level 1, Level 2 should unlock (when campaign files exist)

## Notes
- Campaign level files must be created by the user (no example levels included)
- The system is fully set up and ready to use once campaign level files are added
- Progress is persistent across game sessions
- Font `fnt_ui` is assumed to exist (used in other UI elements)
