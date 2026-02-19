function scr_update_tile(tile_x, tile_y) {
    if (!instance_exists(obj_controller)) {
        show_debug_message("ERROR: scr_update_tile called but obj_controller does not exist");
        return;
    }

    var controller = obj_controller;
    var tileType = controller.map[tile_x][tile_y];

    tilemap_set(controller.floor_tilemap_id, 0, tile_x, tile_y);
    tilemap_set(controller.wall_tilemap_id, 0, tile_x, tile_y);

    if (tileType == controller.TILE_FLOOR) {
        tilemap_set(controller.floor_tilemap_id, controller.TILE_FLOOR, tile_x, tile_y);
        return;
    }

    // front-face vs solid wall depends on what's below
    var below_is_floor = (tile_y + 1 >= controller.cell_h) || (controller.map[tile_x][tile_y + 1] == controller.TILE_FLOOR);

    // doors count as floor for rendering purposes
    if (tile_y + 1 < controller.cell_h) {
        if (controller.door_objects[tile_x][tile_y + 1] != noone && instance_exists(controller.door_objects[tile_x][tile_y + 1])) {
            below_is_floor = true;
        }
    }

    if (below_is_floor) {
        tilemap_set(controller.wall_tilemap_id, controller.TILE_WALL_FRONT, tile_x, tile_y);
    } else {
        tilemap_set(controller.wall_tilemap_id, controller.TILE_WALL_SOLID, tile_x, tile_y);
    }
}
