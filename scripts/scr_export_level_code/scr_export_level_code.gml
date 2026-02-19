// copies a shareable level code to clipboard
function scr_export_level_code(){
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: Cannot export level - obj_controller does not exist");
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

    // save spawn point
    if (instance_exists(controller.player_spawn_instance)) {
        level_data.player_spawn = {
            x: controller.player_spawn_instance.x,
            y: controller.player_spawn_instance.y
        };
    }

    // save extraction
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

    // save cameras with rotation data
    with (obj_security_cam) {
        array_push(level_data.security_cams, {
            x: x,
            y: y,
            cone_direction: cone_direction,
            start_direction: start_direction,
            sweep_range: sweep_range
        });
    }

    // save guards with instance id
    with (obj_guard) {
        var guard_data = {
            x: x,
            y: y,
            facing_direction: facing_direction,
            guard_instance_id: id
        };
        array_push(level_data.guards, guard_data);
    }

    // save waypoints with guard reference
    with (obj_waypoint) {
        var waypoint_data = {
            x: x,
            y: y,
            waypoint_id: waypoint_id,
            guard_instance_id: guard_id
        };
        array_push(level_data.waypoints, waypoint_data);
    }

    // save doors
    with (obj_door) {
        array_push(level_data.doors, {
            x: x,
            y: y,
            door_direction: door_direction,
            is_open: is_open
        });
    }

    // convert to compact json
    var json_string = json_stringify(level_data, false);

    // encode as base64
    var buffer = buffer_create(string_byte_length(json_string), buffer_fixed, 1);
    buffer_write(buffer, buffer_text, json_string);
    buffer_seek(buffer, buffer_seek_start, 0);
    var encoded = buffer_base64_encode(buffer, 0, buffer_get_size(buffer));
    buffer_delete(buffer);

    // add version header
    var level_code = "STEALTHV1:" + encoded;

    // copy to clipboard
    clipboard_set_text(level_code);

    show_debug_message("Level code exported to clipboard");
    show_debug_message("Code length: " + string(string_length(level_code)) + " characters");

    return level_code;
}
