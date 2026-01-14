// Update visibility based on game mode and goal completion
if (instance_exists(obj_controller)) {
    // In build mode, always visible
    if (obj_controller.game_mode == "build") {
        visible = true;
    } else {
        // In play mode, only visible if all goals collected
        var all_goals_collected = (obj_controller.goals_collected >= obj_controller.total_goals);
        visible = all_goals_collected;

        // Check if player touches extraction point (win condition)
        if (all_goals_collected && instance_exists(obj_player)) {
            var dist = point_distance(x, y, obj_player.x, obj_player.y);
            if (dist <= 32) {
                // Win condition met!
                show_debug_message("Victory! All goals collected and extraction reached!");

                // Create win screen (only once)
                if (!instance_exists(obj_win_screen)) {
                    instance_create_layer(0, 0, "Instances", obj_win_screen);
                }
            }
        }
    }
}
