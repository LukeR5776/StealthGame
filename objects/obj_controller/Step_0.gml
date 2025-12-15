// Cycle through placeable objects with Q/E keys
if (keyboard_check_pressed(ord("Q"))) {
    current_selection--;
    if (current_selection < 0) current_selection = PLACE_DOOR;
}
if (keyboard_check_pressed(ord("E"))) {
    current_selection++;
    if (current_selection > PLACE_DOOR) current_selection = PLACE_WALL;
}

// Rotate camera placement direction with R/T keys (only when security cam selected)
if (current_selection == PLACE_SECURITY_CAM) {
    if (keyboard_check_pressed(ord("R"))) {
        camera_placement_direction += 45;
        if (camera_placement_direction >= 360) camera_placement_direction -= 360;
    }
    if (keyboard_check_pressed(ord("T"))) {
        camera_placement_direction -= 45;
        if (camera_placement_direction < 0) camera_placement_direction += 360;
    }
}

// Rotate guard placement direction with R/T keys (only when guard selected)
if (current_selection == PLACE_GUARD) {
    if (keyboard_check_pressed(ord("R"))) {
        guard_placement_direction += 45;
        if (guard_placement_direction >= 360) guard_placement_direction -= 360;
    }
    if (keyboard_check_pressed(ord("T"))) {
        guard_placement_direction -= 45;
        if (guard_placement_direction < 0) guard_placement_direction += 360;
    }
}

// Rotate door placement direction with R/T keys (only when door selected)
if (current_selection == PLACE_DOOR) {
    if (keyboard_check_pressed(ord("R"))) {
        door_placement_direction += 90;
        if (door_placement_direction >= 360) door_placement_direction -= 360;
    }
    if (keyboard_check_pressed(ord("T"))) {
        door_placement_direction -= 90;
        if (door_placement_direction < 0) door_placement_direction += 360;
    }
}

// Number keys (1-9) to select guard for waypoint assignment
for (var i = 1; i <= 9; i++) {
    if (keyboard_check_pressed(ord(string(i)))) {
        selected_guard_number = i;

        // Find the Nth guard instance
        var guard_list = [];
        with (obj_guard) {
            array_push(guard_list, id);
        }

        if (i <= array_length(guard_list)) {
            selected_guard_id = guard_list[i - 1];
            next_waypoint_id = 0; // Reset waypoint counter for new guard
        } else {
            selected_guard_id = noone;
        }
        break;
    }
}

// Left-click to place selected object
if (mouse_check_button(mb_left)) {
    var tile_x = mouse_x div tile_w;
    var tile_y = mouse_y div tile_h;

    if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {

        // Place based on current selection
        if (current_selection == PLACE_WALL) {
            // Only place if not already a wall
            if (map[tile_x][tile_y] == TILE_FLOOR) {
                map[tile_x][tile_y] = TILE_WALL_FRONT;
                scr_update_tile(tile_x, tile_y);

                if (tile_y > 0) {
                    scr_update_tile(tile_x, tile_y - 1);
                }

                var wall_x = tile_x * tile_w;
                var wall_y = tile_y * tile_h;
                var wall_inst = instance_create_layer(wall_x, wall_y, "Instances", obj_wall);
                wall_inst.depth = -wall_y;
                wall_objects[tile_x][tile_y] = wall_inst;
            }
        }
        else if (current_selection == PLACE_PLAYER_SPAWN) {
            // Remove old spawn if it exists
            if (instance_exists(player_spawn_instance)) {
                instance_destroy(player_spawn_instance);
            }

            // Place new spawn
            var spawn_x = tile_x * tile_w;
            var spawn_y = tile_y * tile_h;
            player_spawn_instance = instance_create_layer(spawn_x, spawn_y, "Instances", obj_player_spawn);
        }
        else if (current_selection == PLACE_GOAL) {
            // Only place if no goal already at this tile
            if (goal_objects[tile_x][tile_y] == noone) {
                var goal_x = tile_x * tile_w;
                var goal_y = tile_y * tile_h;
                goal_objects[tile_x][tile_y] = instance_create_layer(goal_x, goal_y, "Instances", obj_goal);
            }
        }
        else if (current_selection == PLACE_SECURITY_CAM) {
            // Only place if no camera already at this tile
            if (security_cam_objects[tile_x][tile_y] == noone) {
                var cam_x = tile_x * tile_w;
                var cam_y = tile_y * tile_h;
                var new_cam = instance_create_layer(cam_x, cam_y, "Instances", obj_security_cam);

                // Set the camera's initial direction
                new_cam.cone_direction = camera_placement_direction;
                new_cam.start_direction = camera_placement_direction;

                security_cam_objects[tile_x][tile_y] = new_cam;
            }
        }
        else if (current_selection == PLACE_GUARD) {
            // Only place if no guard already at this tile
            if (guard_objects[tile_x][tile_y] == noone) {
                var guard_x = tile_x * tile_w + tile_w / 2;
                var guard_y = tile_y * tile_h + tile_h / 2;
                var new_guard = instance_create_layer(guard_x, guard_y, "Instances", obj_guard);

                // Set the guard's initial direction
                new_guard.facing_direction = guard_placement_direction;

                guard_objects[tile_x][tile_y] = new_guard;
            }
        }
        else if (current_selection == PLACE_WAYPOINT) {
            // Only place if no waypoint already at this tile
            if (waypoint_objects[tile_x][tile_y] == noone) {
                var waypoint_x = tile_x * tile_w + tile_w / 2;
                var waypoint_y = tile_y * tile_h + tile_h / 2;
                var new_waypoint = instance_create_layer(waypoint_x, waypoint_y, "Instances", obj_waypoint);

                // Auto-assign to selected guard
                if (selected_guard_id != noone && instance_exists(selected_guard_id)) {
                    new_waypoint.guard_id = selected_guard_id;
                    new_waypoint.waypoint_id = next_waypoint_id;
                    next_waypoint_id++;
                }

                waypoint_objects[tile_x][tile_y] = new_waypoint;
            }
        }
        else if (current_selection == PLACE_DOOR) {
            // Only place if no door already at this tile
            if (door_objects[tile_x][tile_y] == noone) {
                var door_x = tile_x * tile_w + tile_w / 2;
                var door_y = tile_y * tile_h + tile_h / 2;
                var new_door = instance_create_layer(door_x, door_y, "Instances", obj_door);

                // Set the door's initial direction
                new_door.door_direction = door_placement_direction;

                door_objects[tile_x][tile_y] = new_door;

                // Update tile above (if it exists) to refresh wall rendering
                if (tile_y > 0) {
                    scr_update_tile(tile_x, tile_y - 1);
                }
            }
        }
    }
}
 
// Right-click to remove any placed objects
if (mouse_check_button(mb_right)) {
    var tile_x = mouse_x div tile_w;
    var tile_y = mouse_y div tile_h;

    if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {
        // Remove walls
        if (map[tile_x][tile_y] != TILE_FLOOR) {
            map[tile_x][tile_y] = TILE_FLOOR;
            scr_update_tile(tile_x, tile_y);

            if (tile_y > 0) {
                scr_update_tile(tile_x, tile_y - 1);
            }

            if (wall_objects[tile_x][tile_y] != noone) {
                instance_destroy(wall_objects[tile_x][tile_y]);
                wall_objects[tile_x][tile_y] = noone;
            }
        }

        // Remove player spawn if clicked on it
        if (instance_exists(player_spawn_instance)) {
            var spawn_tile_x = player_spawn_instance.x div tile_w;
            var spawn_tile_y = player_spawn_instance.y div tile_h;

            if (tile_x == spawn_tile_x && tile_y == spawn_tile_y) {
                instance_destroy(player_spawn_instance);
                player_spawn_instance = noone;
            }
        }

        // Remove goal if clicked on it
        if (goal_objects[tile_x][tile_y] != noone) {
            instance_destroy(goal_objects[tile_x][tile_y]);
            goal_objects[tile_x][tile_y] = noone;
        }

        // Remove security camera if clicked on it
        if (security_cam_objects[tile_x][tile_y] != noone) {
            instance_destroy(security_cam_objects[tile_x][tile_y]);
            security_cam_objects[tile_x][tile_y] = noone;
        }

        // Remove guard if clicked on it
        if (guard_objects[tile_x][tile_y] != noone) {
            instance_destroy(guard_objects[tile_x][tile_y]);
            guard_objects[tile_x][tile_y] = noone;
        }

        // Remove waypoint if clicked on it
        if (waypoint_objects[tile_x][tile_y] != noone) {
            instance_destroy(waypoint_objects[tile_x][tile_y]);
            waypoint_objects[tile_x][tile_y] = noone;
        }

        // Remove door if clicked on it
        if (door_objects[tile_x][tile_y] != noone) {
            instance_destroy(door_objects[tile_x][tile_y]);
            door_objects[tile_x][tile_y] = noone;

            // Update tile above (if it exists) to refresh wall rendering
            if (tile_y > 0) {
                scr_update_tile(tile_x, tile_y - 1);
            }
        }
    }
}

// Space key to respawn player at spawn point or create player if none exists
if (keyboard_check_pressed(vk_space)) {
    if (instance_exists(player_spawn_instance)) {
        if (instance_exists(obj_player)) {
            // Respawn existing player
            obj_player.x = player_spawn_instance.x;
            obj_player.y = player_spawn_instance.y;
        } else {
            // Create new player at spawn
            instance_create_layer(player_spawn_instance.x, player_spawn_instance.y, "Instances", obj_player);
        }
    }
}