move_speed = 1;
facing_direction = 0;
rotation_speed = 2;
prev_x = x;
prev_y = y;

cone_angle = 20;
cone_length = 200;
player_detected = false;
is_unconscious = false;

state = "PATROL";

path = path_add();
grid = noone;
grid_initialized = false;

my_waypoints = [];
current_waypoint_index = 0;
waypoint_reached_distance = 16;
path_calculated = false;

depth = -y;
