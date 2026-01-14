// Increment independent sweep timer
sweep_timer += 1 / room_speed; // Add delta time in seconds

cam_x = x+16; //Offset
cam_y = y+16; //Offset

// Smooth sweep using sine wave
var sweep_speed = 0.5; // How fast the sweep oscillates (lower = slower)
var normalized_sweep = sin(sweep_timer * sweep_speed); // Oscillates between -1 and 1

// Map the sine wave to the sweep range
cone_direction = start_direction + (normalized_sweep * sweep_range);

// Reset detection state
player_detected = false;

// Check if player exists
if (instance_exists(obj_player)) {
    // Define 5 key points to check on the player sprite
    var check_points = [
        [(obj_player.bbox_left + obj_player.bbox_right) / 2, (obj_player.bbox_top + obj_player.bbox_bottom) / 2], // Center
        [obj_player.bbox_left, obj_player.bbox_top],     // Top-left
        [obj_player.bbox_right, obj_player.bbox_top],    // Top-right
        [obj_player.bbox_left, obj_player.bbox_bottom],  // Bottom-left
        [obj_player.bbox_right, obj_player.bbox_bottom]  // Bottom-right
    ];

    // Check each point
    for (var i = 0; i < 5; i++) {
        var check_x = check_points[i][0];
        var check_y = check_points[i][1];

        // Check if this point is within range
        var dist_to_point = point_distance(cam_x, cam_y, check_x, check_y);
        if (dist_to_point <= cone_length) {
            // Calculate angle to this point
            var angle_to_point = point_direction(cam_x, cam_y, check_x, check_y);

            // Calculate angle difference
            var angle_diff = angle_difference(cone_direction, angle_to_point);

            // Check if point is within cone angle
            if (abs(angle_diff) <= cone_angle) {
                // Check if line of sight to this point is blocked by vision blockers
                var collision = collision_line(cam_x, cam_y, check_x, check_y, obj_vision_blocker, false, true);

                // If no vision blocker blocks the view, player is detected
                if (collision == noone) {
                    player_detected = true;
					if alarm[0] <= 0 {
					alarm[0] = 40; //detection alarm
					}
                    break; // No need to check remaining points
                }
            }
        }
    }
}
