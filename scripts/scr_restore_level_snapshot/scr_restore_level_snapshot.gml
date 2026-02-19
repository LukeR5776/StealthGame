function scr_restore_level_snapshot(snapshot_data){
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: Cannot restore snapshot - obj_controller does not exist");
        return false;
    }

    if (snapshot_data == undefined) {
        show_debug_message("ERROR: Cannot restore - snapshot data is undefined");
        return false;
    }

    var controller = obj_controller;

    scr_clear_level();

    if (snapshot_data.grid.cell_w != controller.cell_w || snapshot_data.grid.cell_h != controller.cell_h) {
        show_debug_message("WARNING: Snapshot dimensions don't match current grid. Loading anyway...");
    }

    // first pass: map data + walls
    for (var i = 0; i < controller.cell_w && i < array_length(snapshot_data.tiles); i++) {
        for (var j = 0; j < controller.cell_h && j < array_length(snapshot_data.tiles[i]); j++) {
            controller.map[i][j] = snapshot_data.tiles[i][j];

            if (snapshot_data.tiles[i][j] == controller.TILE_WALL_SOLID ||
                snapshot_data.tiles[i][j] == controller.TILE_WALL_FRONT) {
                var wall_x = i * controller.tile_w;
                var wall_y = j * controller.tile_h;
                var wall_inst = instance_create_layer(wall_x, wall_y, "Instances", obj_wall);
                controller.wall_objects[i][j] = wall_inst;
            }
        }
    }

    // second pass: visuals
    for (var i = 0; i < controller.cell_w && i < array_length(snapshot_data.tiles); i++) {
        for (var j = 0; j < controller.cell_h && j < array_length(snapshot_data.tiles[i]); j++) {
            scr_update_tile(i, j);
        }
    }

    if (snapshot_data.player_spawn != undefined) {
        controller.player_spawn_instance = instance_create_layer(
            snapshot_data.player_spawn.x,
            snapshot_data.player_spawn.y,
            "Instances",
            obj_player_spawn
        );
    }

    if (snapshot_data.extraction != undefined) {
        controller.extraction_instance = instance_create_layer(
            snapshot_data.extraction.x,
            snapshot_data.extraction.y,
            "Instances",
            obj_extraction
        );
    }

    for (var i = 0; i < array_length(snapshot_data.goals); i++) {
        var goal_data = snapshot_data.goals[i];
        var goal_inst = instance_create_layer(goal_data.x, goal_data.y, "Instances", obj_goal);

        var tile_x = goal_data.x div controller.tile_w;
        var tile_y = goal_data.y div controller.tile_h;
        controller.goal_objects[tile_x][tile_y] = goal_inst;
    }

    for (var i = 0; i < array_length(snapshot_data.security_cams); i++) {
        var cam_data = snapshot_data.security_cams[i];
        var cam_inst = instance_create_layer(cam_data.x, cam_data.y, "Instances", obj_security_cam);

        cam_inst.cone_direction = cam_data.cone_direction;
        cam_inst.start_direction = cam_data.start_direction;
        cam_inst.sweep_range = cam_data.sweep_range;

        var tile_x = cam_data.x div controller.tile_w;
        var tile_y = cam_data.y div controller.tile_h;
        controller.security_cam_objects[tile_x][tile_y] = cam_inst;
    }

    // guards - build id map for waypoint linking
    var guard_id_map = ds_map_create();

    for (var i = 0; i < array_length(snapshot_data.guards); i++) {
        var guard_data = snapshot_data.guards[i];
        var guard_inst = instance_create_layer(guard_data.x, guard_data.y, "Instances", obj_guard);

        guard_inst.facing_direction = guard_data.facing_direction;
        guard_inst.is_unconscious = false;
        guard_id_map[? guard_data.guard_instance_id] = guard_inst;

        var tile_x = guard_data.x div controller.tile_w;
        var tile_y = guard_data.y div controller.tile_h;
        controller.guard_objects[tile_x][tile_y] = guard_inst;
    }

    for (var i = 0; i < array_length(snapshot_data.waypoints); i++) {
        var waypoint_data = snapshot_data.waypoints[i];
        var waypoint_inst = instance_create_layer(waypoint_data.x, waypoint_data.y, "Instances", obj_waypoint);

        waypoint_inst.waypoint_id = waypoint_data.waypoint_id;

        // remap guard id
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

    // always reset doors to closed
    for (var i = 0; i < array_length(snapshot_data.doors); i++) {
        var door_data = snapshot_data.doors[i];
        var door_inst = instance_create_layer(door_data.x, door_data.y, "Instances", obj_door);

        door_inst.door_direction = door_data.door_direction;
        door_inst.is_open = false;
        door_inst.is_locked = door_data.is_locked;
        door_inst.lockpick_progress = 0;

        var tile_x = door_data.x div controller.tile_w;
        var tile_y = door_data.y div controller.tile_h;
        controller.door_objects[tile_x][tile_y] = door_inst;
    }

    // Reset goal collection counter
    controller.goals_collected = 0;
    controller.total_goals = instance_number(obj_goal);

    show_debug_message("Level snapshot restored successfully");
    return true;
}