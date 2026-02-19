// in-memory snapshot for build<->play transitions
function scr_create_level_snapshot(){
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: Cannot create snapshot - obj_controller does not exist");
        return undefined;
    }

    var controller = obj_controller;

    var level_data = {
        version: "1.0",
        grid: {
            cell_w: controller.cell_w,
            cell_h: controller.cell_h,
            tile_w: controller.tile_w,
            tile_h: controller.tile_h
        },
        tiles: [],
        player_spawn: undefined,
        extraction: undefined,
        goals: [],
        security_cams: [],
        guards: [],
        waypoints: [],
        doors: []
    };

    for (var i = 0; i < controller.cell_w; i++) {
        level_data.tiles[i] = [];
        for (var j = 0; j < controller.cell_h; j++) {
            level_data.tiles[i][j] = controller.map[i][j];
        }
    }

    if (instance_exists(controller.player_spawn_instance)) {
        level_data.player_spawn = {
            x: controller.player_spawn_instance.x,
            y: controller.player_spawn_instance.y
        };
    }

    if (instance_exists(controller.extraction_instance)) {
        level_data.extraction = {
            x: controller.extraction_instance.x,
            y: controller.extraction_instance.y
        };
    }

    // save all goals
    with (obj_goal) {
        array_push(level_data.goals, {
            x: x,
            y: y
        });
    }

    with (obj_security_cam) {
        array_push(level_data.security_cams, {
            x: x,
            y: y,
            cone_direction: cone_direction,
            start_direction: start_direction,
            sweep_range: sweep_range
        });
    }

    // store instance id so waypoints can link back
    with (obj_guard) {
        var guard_data = {
            x: x,
            y: y,
            facing_direction: facing_direction,
            guard_instance_id: id
        };
        array_push(level_data.guards, guard_data);
    }

    with (obj_waypoint) {
        var waypoint_data = {
            x: x,
            y: y,
            waypoint_id: waypoint_id,
            guard_instance_id: guard_id
        };
        array_push(level_data.waypoints, waypoint_data);
    }

    // always reset doors to closed
    with (obj_door) {
        array_push(level_data.doors, {
            x: x,
            y: y,
            door_direction: door_direction,
            is_open: false,
            is_locked: is_locked
        });
    }

    show_debug_message("Level snapshot created successfully");
    return level_data;
}