function scr_update_tile(x, y) {

    var tileType = map[x][y];

    // Clear both layers first
    tilemap_set(floor_tilemap_id, 0, x, y);
    tilemap_set(wall_tilemap_id, 0, x, y);

    // Set floor tile on floor layer
    if (tileType == TILE_FLOOR) {
        tilemap_set(floor_tilemap_id, TILE_FLOOR, x, y);
        return;
    }

    // Set wall tile on wall layer + check if tile below is floor, wall, or has a door
    var below_is_floor = (y + 1 >= cell_h) || (map[x][y + 1] == TILE_FLOOR);

    // Also check if there's a door in the tile below (doors act as floor for wall rendering)
    if (y + 1 < cell_h && instance_exists(obj_controller)) {
        if (obj_controller.door_objects[x][y + 1] != noone && instance_exists(obj_controller.door_objects[x][y + 1])) {
            below_is_floor = true;
        }
    }

    if (below_is_floor) {
        // Front-facing wall
        tilemap_set(wall_tilemap_id, TILE_WALL_FRONT, x, y);
    } else {
        // Solid wall
        tilemap_set(wall_tilemap_id, TILE_WALL_SOLID, x, y);
    }
}

