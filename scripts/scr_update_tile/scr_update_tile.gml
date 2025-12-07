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

    // Set wall tile on wall layer + check if tile below is floor or wall
    var below_is_floor = (y + 1 >= cell_h) || (map[x][y + 1] == TILE_FLOOR);

    if (below_is_floor) {
        // Front-facing wall
        tilemap_set(wall_tilemap_id, TILE_WALL_FRONT, x, y);
    } else {
        // Solid wall
        tilemap_set(wall_tilemap_id, TILE_WALL_SOLID, x, y);
    }
}

