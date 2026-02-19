
if (keyboard_check_pressed(ord("P"))) {
    if (game_mode == "build") {

        var missing = [];

        if (!instance_exists(player_spawn_instance)) {
            array_push(missing, "Player Spawn");
        }

        if (instance_number(obj_goal) == 0) {
            array_push(missing, "Goal");
        }

        if (!instance_exists(extraction_instance)) {
            array_push(missing, "Extraction");
        }


        if (array_length(missing) == 0) {
            // switch to play mode
            game_mode = "play";
            level_snapshot = scr_create_level_snapshot();
            mode_switch_error = "";

            // count goals
            total_goals = instance_number(obj_goal);
            goals_collected = 0;

            // spawn player
            if (!instance_exists(obj_player)) {
                instance_create_layer(player_spawn_instance.x, player_spawn_instance.y, "Instances", obj_player);
            }


            with (obj_guard) {
                grid_initialized = false;
            }
        } else {
            mode_switch_error = "Missing required objects: ";
            for (var i = 0; i < array_length(missing); i++) {
                mode_switch_error += missing[i];
                if (i < array_length(missing) - 1) {
                    mode_switch_error += ", ";
                }
            }
        }
    } else {
        // back to build mode
        game_mode = "build";
        mode_switch_error = "";

        // restore level state
        scr_restore_level_snapshot(level_snapshot);
    }
}

// pause menu
if (keyboard_check_pressed(ord("M")) && game_mode == "play") {
    if (!instance_exists(obj_pause_menu)) {
        instance_create_layer(0, 0, "Instances", obj_pause_menu);
    }
}

// build mode controls
if (game_mode == "build") {

// Q/E to cycle items
if (keyboard_check_pressed(ord("Q"))) {
    current_selection--;
    if (current_selection < 0) current_selection = PLACE_EXTRACTION;
    carousel_target_offset = current_selection;
}
if (keyboard_check_pressed(ord("E"))) {
    current_selection++;
    if (current_selection > PLACE_EXTRACTION) current_selection = PLACE_WALL;
    carousel_target_offset = current_selection;
}

// R/T to rotate camera
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

// R/T to rotate guard
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

// R/T to rotate door
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

// L to lock/unlock doors
if (keyboard_check_pressed(ord("L"))) {
    var tile_x = mouse_x div tile_w;
    var tile_y = mouse_y div tile_h;

    if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {
        if (door_objects[tile_x][tile_y] != noone && instance_exists(door_objects[tile_x][tile_y])) {
            var door_inst = door_objects[tile_x][tile_y];
            door_inst.is_locked = !door_inst.is_locked;
            door_inst.lockpick_progress = 0;
        }
    }
}

// 1-9 to select guard
for (var i = 1; i <= 9; i++) {
    if (keyboard_check_pressed(ord(string(i)))) {
        selected_guard_number = i;

        var guard_list = [];
        with (obj_guard) {
            array_push(guard_list, id);
        }

        if (i <= array_length(guard_list)) {
            selected_guard_id = guard_list[i - 1];
            next_waypoint_id = 0;
        } else {
            selected_guard_id = noone;
        }
        break;
    }
}

// menu blocks placement
var menu_is_active = false;
if (instance_exists(obj_save_load_menu) && obj_save_load_menu.menu_active) {
    menu_is_active = true;
}
if (instance_exists(obj_win_screen)) {
    menu_is_active = true;
}

// door lock checkbox
if (mouse_check_button_pressed(mb_left) && current_selection == PLACE_DOOR && !menu_is_active) {
    var gui_mx = device_mouse_x_to_gui(0);
    var gui_my = device_mouse_y_to_gui(0);
    if (point_in_rectangle(gui_mx, gui_my, props_checkbox_x1, props_checkbox_y1, props_checkbox_x2, props_checkbox_y2)) {
        door_placement_locked = !door_placement_locked;
    }
}

// left-click to place
if (mouse_check_button(mb_left) && !mouse_over_props_panel && !menu_is_active) {
    var tile_x = mouse_x div tile_w;
    var tile_y = mouse_y div tile_h;

    if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {

        if (current_selection == PLACE_WALL) {
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
            if (instance_exists(player_spawn_instance)) {
                instance_destroy(player_spawn_instance);
            }

            var spawn_x = tile_x * tile_w;
            var spawn_y = tile_y * tile_h;
            player_spawn_instance = instance_create_layer(spawn_x, spawn_y, "Instances", obj_player_spawn);
        }
        else if (current_selection == PLACE_GOAL) {
            if (goal_objects[tile_x][tile_y] == noone) {
                var goal_x = tile_x * tile_w;
                var goal_y = tile_y * tile_h;
                goal_objects[tile_x][tile_y] = instance_create_layer(goal_x, goal_y, "Instances", obj_goal);
            }
        }
        else if (current_selection == PLACE_SECURITY_CAM) {
            if (security_cam_objects[tile_x][tile_y] == noone) {
                var cam_x = tile_x * tile_w;
                var cam_y = tile_y * tile_h;
                var new_cam = instance_create_layer(cam_x, cam_y, "Instances", obj_security_cam);

                new_cam.cone_direction = camera_placement_direction;
                new_cam.start_direction = camera_placement_direction;

                security_cam_objects[tile_x][tile_y] = new_cam;
            }
        }
        else if (current_selection == PLACE_GUARD) {
            if (guard_objects[tile_x][tile_y] == noone) {
                var guard_x = tile_x * tile_w + tile_w / 2;
                var guard_y = tile_y * tile_h + tile_h / 2;
                var new_guard = instance_create_layer(guard_x, guard_y, "Instances", obj_guard);

                new_guard.facing_direction = guard_placement_direction;

                guard_objects[tile_x][tile_y] = new_guard;
            }
        }
        else if (current_selection == PLACE_WAYPOINT) {
            if (waypoint_objects[tile_x][tile_y] == noone) {
                var waypoint_x = tile_x * tile_w + tile_w / 2;
                var waypoint_y = tile_y * tile_h + tile_h / 2;
                var new_waypoint = instance_create_layer(waypoint_x, waypoint_y, "Instances", obj_waypoint);

                // assign to guard
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

                // Set the door's initial direction and lock state
                new_door.door_direction = door_placement_direction;
                new_door.is_locked = door_placement_locked;

                door_objects[tile_x][tile_y] = new_door;

                // Update tile above (if it exists) to refresh wall rendering
                if (tile_y > 0) {
                    scr_update_tile(tile_x, tile_y - 1);
                }
            }
        }
        else if (current_selection == PLACE_EXTRACTION) {
            // Remove old extraction if it exists
            if (instance_exists(extraction_instance)) {
                instance_destroy(extraction_instance);
            }

            // Place new extraction point
            var extraction_x = tile_x * tile_w + tile_w / 2;
            var extraction_y = tile_y * tile_h + tile_h / 2;
            extraction_instance = instance_create_layer(extraction_x, extraction_y, "Instances", obj_extraction);
        }
    }
}
 
// Right-click to remove any placed objects (blocked when over properties panel or menu active)
if (mouse_check_button(mb_right) && !mouse_over_props_panel && !menu_is_active) {
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

        // Remove extraction if clicked on it
        if (instance_exists(extraction_instance)) {
            var extraction_tile_x = extraction_instance.x div tile_w;
            var extraction_tile_y = extraction_instance.y div tile_h;

            if (tile_x == extraction_tile_x && tile_y == extraction_tile_y) {
                instance_destroy(extraction_instance);
                extraction_instance = noone;
            }
        }
    }
}


// ESC key to open save/load menu (only in build mode)
if (keyboard_check_pressed(vk_escape) && game_mode == "build") {
    if (instance_exists(obj_save_load_menu)) {
        obj_save_load_menu.menu_active = !obj_save_load_menu.menu_active;
    }
}

// Smooth carousel animation
if (carousel_visual_offset != carousel_target_offset) {
    carousel_visual_offset = lerp(carousel_visual_offset, carousel_target_offset, carousel_anim_speed);
    // Snap when very close to prevent endless tiny movements
    if (abs(carousel_visual_offset - carousel_target_offset) < 0.01) {
        carousel_visual_offset = carousel_target_offset;
    }
}

} // End of build mode check