// unconscious guards don't do anything
if (is_unconscious) {
    depth = -y;
    exit;
}

// pathfinding grid setup
if (!grid_initialized && instance_exists(obj_controller)) {
    if (grid != -1) {
        mp_grid_destroy(grid);
    }

    var grid_width = obj_controller.cell_w;
    var grid_height = obj_controller.cell_h;
    var tile_w = obj_controller.tile_w;
    var tile_h = obj_controller.tile_h;

    grid = mp_grid_create(0, 0, grid_width, grid_height, tile_w, tile_h);

    for (var i = 0; i < grid_width; i++) {
        for (var j = 0; j < grid_height; j++) {
            if (obj_controller.map[i][j] != obj_controller.TILE_FLOOR) {
                mp_grid_add_cell(grid, i, j);
            }
        }
    }

    grid_initialized = true;
}

// gather waypoints for this guard
my_waypoints = [];
with (obj_waypoint) {
    if (guard_id == other.id) {
        array_push(other.my_waypoints, id);
    }
}

if (array_length(my_waypoints) > 1) {
    array_sort(my_waypoints, function(a, b) {
        return a.waypoint_id - b.waypoint_id;
    });
}

// AI states
switch (state) {
    case "PATROL":
        if (array_length(my_waypoints) > 0) {
            var target_waypoint = my_waypoints[current_waypoint_index];

            if (instance_exists(target_waypoint)) {
                var dist_to_waypoint = point_distance(x, y, target_waypoint.x, target_waypoint.y);

                // recalc if stuck
                if (path_calculated && path_index == -1 && dist_to_waypoint >= waypoint_reached_distance) {
                    path_calculated = false;
                }

                // cycle waypoints
                if (dist_to_waypoint < waypoint_reached_distance) {
                    path_end();
                    path_calculated = false;

                    current_waypoint_index++;
                    if (current_waypoint_index >= array_length(my_waypoints)) {
                        current_waypoint_index = 0;
                    }

                    target_waypoint = my_waypoints[current_waypoint_index];
                }

                // pathfinding
                if (!path_calculated && grid_initialized && instance_exists(target_waypoint)) {
                    var path_found = mp_grid_path(grid, path, x, y, target_waypoint.x, target_waypoint.y, false);
                    if (path_found) {
                        path_start(path, move_speed, path_action_stop, false);
                        path_calculated = true;
                    }
                }

                // smooth turning
                var moved = point_distance(x, y, prev_x, prev_y);
                if (moved > 0.1) {
                    var move_direction = point_direction(prev_x, prev_y, x, y);
                    var angle_diff = angle_difference(move_direction, facing_direction);

                    if (abs(angle_diff) <= rotation_speed) {
                        facing_direction = move_direction;
                    } else {
                        if (angle_diff > 0) {
                            facing_direction += rotation_speed;
                        } else {
                            facing_direction -= rotation_speed;
                        }

                        if (facing_direction < 0) facing_direction += 360;
                        if (facing_direction >= 360) facing_direction -= 360;
                    }
                }

                prev_x = x;
                prev_y = y;
            }
        }
        break;

    case "INVESTIGATE":
        break;

    case "CHASE":
        break;
}

// vision cone detection
player_detected = false;

// spot knocked out guards
with (obj_guard) {
    if (is_unconscious && id != other.id) {
        var guard_check_points = [
            [(bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2],
            [bbox_left, bbox_top],
            [bbox_right, bbox_top],
            [bbox_left, bbox_bottom],
            [bbox_right, bbox_bottom]
        ];

        for (var i = 0; i < 5; i++) {
            var check_x = guard_check_points[i][0];
            var check_y = guard_check_points[i][1];

            var dist_to_point = point_distance(other.x, other.y, check_x, check_y);
            if (dist_to_point <= other.cone_length) {
                var angle_to_point = point_direction(other.x, other.y, check_x, check_y);
                var angle_diff = angle_difference(other.facing_direction, angle_to_point);

                if (abs(angle_diff) <= other.cone_angle) {
                    var collision = collision_line(other.x, other.y, check_x, check_y, obj_vision_blocker, false, true);

                    if (collision == noone) {
                        other.player_detected = true;
                        if (other.alarm[0] <= 0) {
                            other.alarm[0] = 20;
                        }
                        break;
                    }
                }
            }
        }

        if (other.player_detected) {
            break;
        }
    }
}

if (instance_exists(obj_player)) {
    var check_points = [
        [(obj_player.bbox_left + obj_player.bbox_right) / 2, (obj_player.bbox_top + obj_player.bbox_bottom) / 2],
        [obj_player.bbox_left, obj_player.bbox_top],
        [obj_player.bbox_right, obj_player.bbox_top],
        [obj_player.bbox_left, obj_player.bbox_bottom],
        [obj_player.bbox_right, obj_player.bbox_bottom]
    ];

    for (var i = 0; i < 5; i++) {
        var check_x = check_points[i][0];
        var check_y = check_points[i][1];

        var dist_to_point = point_distance(x, y, check_x, check_y);
        if (dist_to_point <= cone_length) {
            var angle_to_point = point_direction(x, y, check_x, check_y);
            var angle_diff = angle_difference(facing_direction, angle_to_point);

            if (abs(angle_diff) <= cone_angle) {
                var collision = collision_line(x, y, check_x, check_y, obj_vision_blocker, false, true);

                if (collision == noone) {
                    player_detected = true;
				if alarm[0] <= 0 {
					alarm[0] = 20;
				}
                    break;
                }
            }
        }
    }
}

depth = -y;
