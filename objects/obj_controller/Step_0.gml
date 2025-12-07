// Cycle through placeable objects with Q/E keys
if (keyboard_check_pressed(ord("Q"))) {
    current_selection--;
    if (current_selection < 0) current_selection = PLACE_SECURITY_CAM;
}
if (keyboard_check_pressed(ord("E"))) {
    current_selection++;
    if (current_selection > PLACE_SECURITY_CAM) current_selection = PLACE_WALL;
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