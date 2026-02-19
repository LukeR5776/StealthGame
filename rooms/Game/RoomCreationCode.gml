// load campaign level if coming from campaign menu
if (global.campaign_mode && global.current_campaign_level > 0) {
    var level = get_campaign_level_by_num(global.current_campaign_level);

    if (level != undefined) {
        var campaign_dir = game_save_id + "campaign/";
        var filepath = campaign_dir + level.filename + ".json";

        if (file_exists(filepath)) {
            show_debug_message("Loading campaign level: " + level.title);

                if (scr_load_campaign_level(level.filename)) {
                // Set game to play mode
                if (instance_exists(obj_controller)) {
                    obj_controller.game_mode = "play";

                    obj_controller.total_goals = instance_number(obj_goal);
                    obj_controller.goals_collected = 0;

                    if (instance_exists(obj_controller.player_spawn_instance)) {
                        if (!instance_exists(obj_player)) {
                            instance_create_layer(
                                obj_controller.player_spawn_instance.x,
                                obj_controller.player_spawn_instance.y,
                                "Instances",
                                obj_player
                            );
                        }
                    }

                    with (obj_guard) {
                        grid_initialized = false;
                    }
                }

                show_debug_message("Campaign level loaded and started successfully");
            } else {
                show_debug_message("ERROR: Failed to load campaign level file");
            }
        } else {
            show_debug_message("ERROR: Campaign level file not found: " + filepath);
        }
    } else {
        show_debug_message("ERROR: Campaign level data not found for level " + string(global.current_campaign_level));
    }

    global.campaign_mode = false;
}
