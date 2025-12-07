// Tile constants
TILE_FLOOR = 1;
TILE_WALL_SOLID = 2;
TILE_WALL_FRONT = 3;

// Placeable object types for level builder
PLACE_WALL = 0;
PLACE_PLAYER_SPAWN = 1;
PLACE_GOAL = 2;
PLACE_SECURITY_CAM = 3;

// Current selection
current_selection = PLACE_WALL;

// Camera placement direction (for rotating cameras before placing)
camera_placement_direction = 0;

// Tileset reference
ts = tileset_get_info(ts_tiles);
show_debug_message(ts.tile_count);

// Grid settings
tile_w = 32;
tile_h = 32;
cell_w = 20;
cell_h = 20;

// Create separate tile layers for floor and walls
var floor_layer_id = layer_create(0, "Floor_Layer");
floor_tilemap_id = layer_tilemap_create(floor_layer_id, 0, 0, ts_tiles, cell_w, cell_h);

var wall_layer_id = layer_create(-100, "Wall_Layer");
wall_tilemap_id = layer_tilemap_create(wall_layer_id, 0, 0, ts_tiles, cell_w, cell_h);

// Create map array for tile data
map = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    map[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        map[i][j] = TILE_FLOOR;
    }
}

// Create array to track wall collision objects
wall_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    wall_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        wall_objects[i][j] = noone;
    }
}

// Track player spawn object (only one at a time)
player_spawn_instance = noone;

// Create array to track goal objects
goal_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    goal_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        goal_objects[i][j] = noone;
    }
}

// Create array to track security camera objects
security_cam_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    security_cam_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        security_cam_objects[i][j] = noone;
    }
}

// Populate the tilemap with tiles from the map array
for (var i = 0; i < cell_w; i++) {
    for (var j = 0; j < cell_h; j++) {
		scr_update_tile(i, j);
    }
}
