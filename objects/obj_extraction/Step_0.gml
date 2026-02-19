// show when all goals collected
if (instance_exists(obj_controller)) {
    if (obj_controller.game_mode == "build") {
        visible = true;
    } else {
        var all_goals_collected = (obj_controller.goals_collected >= obj_controller.total_goals);
        visible = all_goals_collected;

        // win condition
        if (all_goals_collected && instance_exists(obj_player)) {
            var dist = point_distance(x, y, obj_player.x, obj_player.y);
            if (dist <= 32) {
                show_debug_message("Victory! All goals collected and extraction reached!");

                if (!instance_exists(obj_win_screen)) {
                    instance_create_layer(0, 0, "Instances", obj_win_screen);
                }
            }
        }
    }
}
