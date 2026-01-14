// Check if player is near and presses F key to collect
if (instance_exists(obj_player)) {
    var dist = point_distance(x, y, obj_player.x, obj_player.y);

    // If player is close enough (within 32 pixels)
    if (dist <= 32) {
        // Check for F key press
        if (keyboard_check_pressed(ord("F"))) {
            // Increment goals collected counter
            if (instance_exists(obj_controller)) {
                obj_controller.goals_collected++;
            }

            // Clear from controller's tracking array
            var tile_x = x div obj_controller.tile_w;
            var tile_y = y div obj_controller.tile_h;
            obj_controller.goal_objects[tile_x][tile_y] = noone;

            // Destroy this goal
            instance_destroy();
        }
    }
}
