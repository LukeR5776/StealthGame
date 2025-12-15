// Tile constants
TILE_FLOOR = 1;
TILE_WALL_SOLID = 2;
TILE_WALL_FRONT = 3;

// Placeable object types for level builder
PLACE_WALL = 0;
PLACE_PLAYER_SPAWN = 1;
PLACE_GOAL = 2;
PLACE_SECURITY_CAM = 3;
PLACE_GUARD = 4;
PLACE_WAYPOINT = 5;
PLACE_DOOR = 6;

// Current selection
current_selection = PLACE_WALL;

// Camera placement direction (for rotating cameras before placing)
camera_placement_direction = 0;

// Guard placement direction (for rotating guards before placing)
guard_placement_direction = 0;

// Door placement direction (for rotating doors before placing)
door_placement_direction = 0;

// Waypoint assignment system
selected_guard_id = noone; // Which guard waypoints will be assigned to
selected_guard_number = 0; // Which number key (1-9) was pressed
next_waypoint_id = 0; // Auto-increment for waypoint order

// Tileset reference
ts = tileset_get_info(ts_tiles);
show_debug_message(ts.tile_count);

// Grid settings
tile_w = 32;
tile_h = 32;
cell_w = 20;
cell_h = 12;

// Create separate tile layers for floor and walls
var floor_layer_id = layer_create(0, "Floor_Layer");
floor_tilemap_id = layer_tilemap_create(floor_layer_id, 0, 0, ts_tiles, cell_w, cell_h);
var wall_layer_id = layer_create(0, "Wall_Layer");
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

// Create array to track guard objects
guard_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    guard_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        guard_objects[i][j] = noone;
    }
}

// Create array to track waypoint objects
waypoint_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    waypoint_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        waypoint_objects[i][j] = noone;
    }
}

// Create array to track door objects
door_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    door_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        door_objects[i][j] = noone;
    }
}

// Populate the tilemap with tiles from the map array
for (var i = 0; i < cell_w; i++) {
    for (var j = 0; j < cell_h; j++) {
		scr_update_tile(i, j);
    }
}
