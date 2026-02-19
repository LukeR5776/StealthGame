CAMPAIGN LEVELS DIRECTORY
========================

This directory contains the built-in campaign levels for the game.

HOW TO ADD CAMPAIGN LEVELS:
---------------------------

1. Create a level in the Level Editor (build mode)
2. Save the level using the Save/Load menu (ESC key)
3. Navigate to the save directory (usually in your user game data folder)
4. Find the saved level JSON file
5. Copy it to this directory (datafiles/campaign/)
6. Rename it to match the campaign level filename defined in scr_campaign_levels.gml

Expected filenames (as defined in scr_campaign_levels.gml):
- campaign_level_1.json
- campaign_level_2.json
- campaign_level_3.json
- campaign_level_4.json
- campaign_level_5.json

CAMPAIGN LEVEL METADATA:
------------------------

Each level's title, description, and objectives are defined in:
scripts/scr_campaign_levels/scr_campaign_levels.gml

You can edit that file to change:
- Level titles
- Level descriptions
- Objective text
- Number of campaign levels (add more to the array)

PROGRESSION SYSTEM:
-------------------

Campaign levels unlock linearly:
- Level 1 is always unlocked
- Level 2 unlocks after completing Level 1
- Level 3 unlocks after completing Level 2
- etc.

Progress is saved automatically when completing a level and clicking "Return to Menu".

Progress data is stored in:
<game_save_directory>/campaign/progress.json
