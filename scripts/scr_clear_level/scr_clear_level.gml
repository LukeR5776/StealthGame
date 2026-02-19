function scr_clear_level(){
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: Cannot clear level - obj_controller does not exist");
        return false;
    }

    var controller = obj_controller;

    // activate all so with() can find them
    instance_activate_all();

    with (obj_player) instance_destroy();
    with (obj_player_spawn) instance_destroy();
    with (obj_extraction) instance_destroy();
    with (obj_goal) instance_destroy();
    with (obj_security_cam) instance_destroy();
    with (obj_guard) instance_destroy();
    with (obj_waypoint) instance_destroy();
    with (obj_door) instance_destroy();
    with (obj_wall) instance_destroy();

    controller.player_spawn_instance = noone;
    controller.extraction_instance = noone;
    controller.next_waypoint_id = 0;
    controller.selected_guard_id = noone;
    controller.selected_guard_number = 0;

    for (var i = 0; i < controller.cell_w; i++) {
        for (var j = 0; j < controller.cell_h; j++) {
            controller.map[i][j] = controller.TILE_FLOOR;
            controller.wall_objects[i][j] = noone;
            controller.goal_objects[i][j] = noone;
            controller.security_cam_objects[i][j] = noone;
            controller.guard_objects[i][j] = noone;
            controller.waypoint_objects[i][j] = noone;
            controller.door_objects[i][j] = noone;
        }
    }

    for (var i = 0; i < controller.cell_w; i++) {
        for (var j = 0; j < controller.cell_h; j++) {
            tilemap_set(controller.floor_tilemap_id, controller.TILE_FLOOR, i, j);
            tilemap_set(controller.wall_tilemap_id, 0, i, j);
        }
    }

    show_debug_message("Level cleared successfully");
    return true;
}
