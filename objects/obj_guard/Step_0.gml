// Initialize A* grid on first step
if (!grid_initialized && instance_exists(obj_controller)) {
    // Create grid based on controller's tile system
    var grid_width = obj_controller.cell_w;
    var grid_height = obj_controller.cell_h;
    var tile_w = obj_controller.tile_w;
    var tile_h = obj_controller.tile_h;

    grid = mp_grid_create(0, 0, grid_width, grid_height, tile_w, tile_h);

    // Add walls to grid
    for (var i = 0; i < grid_width; i++) {
        for (var j = 0; j < grid_height; j++) {
            if (obj_controller.map[i][j] != obj_controller.TILE_FLOOR) {
                mp_grid_add_cell(grid, i, j);
            }
        }
    }

    grid_initialized = true;
}

// Collect waypoints assigned to this guard (guard_id matches this instance)
// Always refresh waypoint list to support editor mode (placing waypoints dynamically)
my_waypoints = [];
with (obj_waypoint) {
    if (guard_id == other.id) {
        array_push(other.my_waypoints, id);
    }
}

// Sort waypoints by waypoint_id for proper patrol order
if (array_length(my_waypoints) > 1) {
    array_sort(my_waypoints, function(a, b) {
        return a.waypoint_id - b.waypoint_id;
    });
}

// State machine
switch (state) {
    case "PATROL":
        // Only patrol if we have waypoints
        if (array_length(my_waypoints) > 0) {
            var target_waypoint = my_waypoints[current_waypoint_index];

            // Check if waypoint still exists
            if (instance_exists(target_waypoint)) {
                var dist_to_waypoint = point_distance(x, y, target_waypoint.x, target_waypoint.y);

                // Check if path has ended but we haven't reached the waypoint
                if (path_calculated && path_index == -1 && dist_to_waypoint >= waypoint_reached_distance) {
                    //show_debug_message("Path ended but waypoint not reached! Dist: " + string(dist_to_waypoint));
                    path_calculated = false; // Recalculate path
                }

                // If close enough to waypoint, move to next one
                if (dist_to_waypoint < waypoint_reached_distance) {
                    //show_debug_message("Guard reached waypoint " + string(current_waypoint_index));
                    path_end(); // Stop current path
                    path_calculated = false; // Need new path for next waypoint

                    current_waypoint_index++;
                    if (current_waypoint_index >= array_length(my_waypoints)) {
                        current_waypoint_index = 0; // Loop back to start
                    }

                    //show_debug_message("Moving to next waypoint index: " + string(current_waypoint_index));
                    // Update target to new waypoint
                    target_waypoint = my_waypoints[current_waypoint_index];
                }

                // Calculate path if needed (not in else - always check)
                if (!path_calculated && grid_initialized && instance_exists(target_waypoint)) {
                    //show_debug_message("Attempting pathfind to waypoint " + string(current_waypoint_index) + " at (" + string(target_waypoint.x) + ", " + string(target_waypoint.y) + ")");
                    var path_found = mp_grid_path(grid, path, x, y, target_waypoint.x, target_waypoint.y, false);
                    //show_debug_message("Path found: " + string(path_found));
                    if (path_found) {
                        path_start(path, move_speed, path_action_stop, false);
                        path_calculated = true;
                        //show_debug_message("Path started to waypoint " + string(current_waypoint_index));
                    } else {
                        //show_debug_message("PATHFINDING FAILED for waypoint " + string(current_waypoint_index));
                    }
                }

                // Update facing direction based on actual movement
                var moved = point_distance(x, y, prev_x, prev_y);
                if (moved > 0.1) {
                    var move_direction = point_direction(prev_x, prev_y, x, y);

                    // Smoothly rotate toward the movement direction
                    var angle_diff = angle_difference(move_direction, facing_direction);

                    // If the angle difference is small enough, snap to target
                    if (abs(angle_diff) <= rotation_speed) {
                        facing_direction = move_direction;
                    } else {
                        // Otherwise, rotate by rotation_speed toward the target
                        if (angle_diff > 0) {
                            facing_direction += rotation_speed;
                        } else {
                            facing_direction -= rotation_speed;
                        }

                        // Keep facing_direction in 0-360 range
                        if (facing_direction < 0) facing_direction += 360;
                        if (facing_direction >= 360) facing_direction -= 360;
                    }
                }

                // Update previous position for next frame
                prev_x = x;
                prev_y = y;
            }
        }
        break;

    case "INVESTIGATE":
        // Placeholder for future implementation
        break;

    case "CHASE":
        // Placeholder for future implementation
        break;
}

// Player detection (similar to security camera)
player_detected = false;

if (instance_exists(obj_player)) {
    // Define 5 key points to check on the player sprite
    var check_points = [
        [(obj_player.bbox_left + obj_player.bbox_right) / 2, (obj_player.bbox_top + obj_player.bbox_bottom) / 2],
        [obj_player.bbox_left, obj_player.bbox_top],
        [obj_player.bbox_right, obj_player.bbox_top],
        [obj_player.bbox_left, obj_player.bbox_bottom],
        [obj_player.bbox_right, obj_player.bbox_bottom]
    ];

    // Check each point
    for (var i = 0; i < 5; i++) {
        var check_x = check_points[i][0];
        var check_y = check_points[i][1];

        // Check if this point is within range
        var dist_to_point = point_distance(x, y, check_x, check_y);
        if (dist_to_point <= cone_length) {
            // Calculate angle to this point
            var angle_to_point = point_direction(x, y, check_x, check_y);

            // Calculate angle difference
            var angle_diff = angle_difference(facing_direction, angle_to_point);

            // Check if point is within cone angle
            if (abs(angle_diff) <= cone_angle) {
                // Check if line of sight to this point is blocked by walls
                var collision = collision_line(x, y, check_x, check_y, obj_wall, false, true);

                // If no wall blocks the view, player is detected
                if (collision == noone) {
                    player_detected = true;
					if alarm[0] <= 0 {
						alarm[0] = 20; //detection alarm
					}
                    break;
                }
            }
        }
    }
}

// Update depth for Y-sorting
depth = -y;
