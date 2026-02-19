function scr_import_level_code(){
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: Cannot import level - obj_controller does not exist");
        return false;
    }

    var level_code = clipboard_get_text();

    if (level_code == "") {
        show_debug_message("ERROR: Clipboard is empty");
        return false;
    }

    if (string_pos("STEALTHV1:", level_code) != 1) {
        show_debug_message("ERROR: Invalid level code format - missing header");
        return false;
    }

    // strip header, decode base64
    var encoded = string_delete(level_code, 1, 10);
    var buffer = buffer_base64_decode(encoded);
    if (buffer == -1) {
        show_debug_message("ERROR: Could not decode base64 data");
        return false;
    }

    buffer_seek(buffer, buffer_seek_start, 0);
    var json_string = buffer_read(buffer, buffer_text);
    buffer_delete(buffer);

    // parse json
    var level_data = json_parse(json_string);
    if (level_data == undefined) {
        show_debug_message("ERROR: Could not parse JSON from level code");
        return false;
    }

    // use same loading logic as file load
    var controller = obj_controller;
    scr_clear_level();

    // validate dimensions
    if (level_data.grid.cell_w != controller.cell_w || level_data.grid.cell_h != controller.cell_h) {
        show_debug_message("WARNING: Level dimensions don't match current grid. Loading anyway...");
    }

    // first pass: load map data and create wall objects
    for (var i = 0; i < controller.cell_w && i < array_length(level_data.tiles); i++) {
        for (var j = 0; j < controller.cell_h && j < array_length(level_data.tiles[i]); j++) {
            controller.map[i][j] = level_data.tiles[i][j];

            if (level_data.tiles[i][j] == controller.TILE_WALL_SOLID ||
                level_data.tiles[i][j] == controller.TILE_WALL_FRONT) {
                var wall_x = i * controller.tile_w;
                var wall_y = j * controller.tile_h;
                var wall_inst = instance_create_layer(wall_x, wall_y, "Instances", obj_wall);
                controller.wall_objects[i][j] = wall_inst;
            }
        }
    }

    // second pass: update visuals
    for (var i = 0; i < controller.cell_w && i < array_length(level_data.tiles); i++) {
        for (var j = 0; j < controller.cell_h && j < array_length(level_data.tiles[i]); j++) {
            scr_update_tile(i, j);
        }
    }

    // load spawn
    if (level_data.player_spawn != undefined) {
        controller.player_spawn_instance = instance_create_layer(
            level_data.player_spawn.x,
            level_data.player_spawn.y,
            "Instances",
            obj_player_spawn
        );
    }

    // load extraction
    if (level_data.extraction != undefined) {
        controller.extraction_instance = instance_create_layer(
            level_data.extraction.x,
            level_data.extraction.y,
            "Instances",
            obj_extraction
        );
    }

    // load goals
    for (var i = 0; i < array_length(level_data.goals); i++) {
        var goal_data = level_data.goals[i];
        var goal_inst = instance_create_layer(goal_data.x, goal_data.y, "Instances", obj_goal);

        var tile_x = goal_data.x div controller.tile_w;
        var tile_y = goal_data.y div controller.tile_h;
        controller.goal_objects[tile_x][tile_y] = goal_inst;
    }

    // load cameras
    for (var i = 0; i < array_length(level_data.security_cams); i++) {
        var cam_data = level_data.security_cams[i];
        var cam_inst = instance_create_layer(cam_data.x, cam_data.y, "Instances", obj_security_cam);

        cam_inst.cone_direction = cam_data.cone_direction;
        cam_inst.start_direction = cam_data.start_direction;
        cam_inst.sweep_range = cam_data.sweep_range;

        var tile_x = cam_data.x div controller.tile_w;
        var tile_y = cam_data.y div controller.tile_h;
        controller.security_cam_objects[tile_x][tile_y] = cam_inst;
    }

    // load guards and build mapping
    var guard_id_map = ds_map_create();

    for (var i = 0; i < array_length(level_data.guards); i++) {
        var guard_data = level_data.guards[i];
        var guard_inst = instance_create_layer(guard_data.x, guard_data.y, "Instances", obj_guard);

        guard_inst.facing_direction = guard_data.facing_direction;
        guard_id_map[? guard_data.guard_instance_id] = guard_inst;

        var tile_x = guard_data.x div controller.tile_w;
        var tile_y = guard_data.y div controller.tile_h;
        controller.guard_objects[tile_x][tile_y] = guard_inst;
    }

    // load waypoints and link to guards
    for (var i = 0; i < array_length(level_data.waypoints); i++) {
        var waypoint_data = level_data.waypoints[i];
        var waypoint_inst = instance_create_layer(waypoint_data.x, waypoint_data.y, "Instances", obj_waypoint);

        waypoint_inst.waypoint_id = waypoint_data.waypoint_id;

        if (ds_map_exists(guard_id_map, waypoint_data.guard_instance_id)) {
            var new_guard_inst = guard_id_map[? waypoint_data.guard_instance_id];
            waypoint_inst.guard_id = new_guard_inst;
            array_push(new_guard_inst.my_waypoints, waypoint_inst);
        }

        var tile_x = waypoint_data.x div controller.tile_w;
        var tile_y = waypoint_data.y div controller.tile_h;
        controller.waypoint_objects[tile_x][tile_y] = waypoint_inst;

        if (waypoint_data.waypoint_id >= controller.next_waypoint_id) {
            controller.next_waypoint_id = waypoint_data.waypoint_id + 1;
        }
    }

    // sort waypoints
    with (obj_guard) {
        var len = array_length(my_waypoints);
        for (var i = 0; i < len - 1; i++) {
            for (var j = 0; j < len - i - 1; j++) {
                if (my_waypoints[j].waypoint_id > my_waypoints[j + 1].waypoint_id) {
                    var temp = my_waypoints[j];
                    my_waypoints[j] = my_waypoints[j + 1];
                    my_waypoints[j + 1] = temp;
                }
            }
        }
    }

    ds_map_destroy(guard_id_map);

    // load doors
    for (var i = 0; i < array_length(level_data.doors); i++) {
        var door_data = level_data.doors[i];
        var door_inst = instance_create_layer(door_data.x, door_data.y, "Instances", obj_door);

        door_inst.door_direction = door_data.door_direction;
        door_inst.is_open = door_data.is_open;

        var tile_x = door_data.x div controller.tile_w;
        var tile_y = door_data.y div controller.tile_h;
        controller.door_objects[tile_x][tile_y] = door_inst;
    }

    // Reset snapshot when importing a new level
    controller.level_snapshot = undefined;

    show_debug_message("Level imported successfully from clipboard code");
    return true;
}
