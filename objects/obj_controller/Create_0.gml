
game_mode = "build";
mode_switch_error = "";
level_snapshot = undefined;

goals_collected = 0;
total_goals = 0;

TILE_FLOOR = 1;
TILE_WALL_SOLID = 2;
TILE_WALL_FRONT = 3;

PLACE_WALL = 0;
PLACE_PLAYER_SPAWN = 1;
PLACE_GOAL = 2;
PLACE_SECURITY_CAM = 3;
PLACE_GUARD = 4;
PLACE_WAYPOINT = 5;
PLACE_DOOR = 6;
PLACE_EXTRACTION = 7;

current_selection = PLACE_WALL;

// build mode carousel
carousel_items = [
    { sprite: spr_wall,         name: "Wall",         origin_centered: false },
    { sprite: spr_player_spawn, name: "Player Spawn", origin_centered: false },
    { sprite: spr_goal,         name: "Goal",         origin_centered: false },
    { sprite: spr_security_cam, name: "Security Cam", origin_centered: false },
    { sprite: spr_guard,        name: "Guard",        origin_centered: true  },
    { sprite: -1,               name: "Waypoint",     origin_centered: true  },
    { sprite: spr_door_forward, name: "Door",         origin_centered: false },
    { sprite: spr_extraction,   name: "Extraction",   origin_centered: false }
];
carousel_item_count = 8;

carousel_visual_offset = 0;
carousel_target_offset = 0;
carousel_anim_speed = 0.15;

carousel_y = 50;
carousel_item_spacing = 80;
carousel_selected_scale = 2.0;
carousel_unselected_scale = 1.25;
carousel_visible_distance = 3;

props_panel_x = 10;
props_panel_y = 130;
props_panel_width = 140;
props_panel_padding = 8;
props_checkbox_size = 16;
props_row_height = 24;
mouse_over_props_panel = false;
door_placement_locked = false;

props_checkbox_x1 = 0;
props_checkbox_y1 = 0;
props_checkbox_x2 = 0;
props_checkbox_y2 = 0;

camera_placement_direction = 0;
guard_placement_direction = 0;
door_placement_direction = 0;

selected_guard_id = noone; 
selected_guard_number = 0; 
next_waypoint_id = 0;

ts = tileset_get_info(ts_tiles);
show_debug_message(ts.tile_count);

tile_w = 32;
tile_h = 32;
cell_w = 40;
cell_h = 23;

// tilemap setup
var floor_layer_id = layer_create(0, "Floor_Layer");
floor_tilemap_id = layer_tilemap_create(floor_layer_id, 0, 0, ts_tiles, cell_w, cell_h);
var wall_layer_id = layer_create(0, "Wall_Layer");
wall_tilemap_id = layer_tilemap_create(wall_layer_id, 0, 0, ts_tiles, cell_w, cell_h);

// tile grid
map = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    map[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        map[i][j] = TILE_FLOOR;
    }
}

// wall collision tracking
wall_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    wall_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        wall_objects[i][j] = noone;
    }
}


player_spawn_instance = noone;
extraction_instance = noone;

goal_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    goal_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        goal_objects[i][j] = noone;
    }
}

security_cam_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    security_cam_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        security_cam_objects[i][j] = noone;
    }
}

guard_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    guard_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        guard_objects[i][j] = noone;
    }
}


waypoint_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    waypoint_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        waypoint_objects[i][j] = noone;
    }
}

door_objects = array_create(cell_w);
for (var i = 0; i < cell_w; i++) {
    door_objects[i] = array_create(cell_h);
    for (var j = 0; j < cell_h; j++) {
        door_objects[i][j] = noone;
    }
}

// init tiles
for (var i = 0; i < cell_w; i++) {
    for (var j = 0; j < cell_h; j++) {
		scr_update_tile(i, j);
    }
}
