// Movement properties
move_speed = 1;
facing_direction = 0; // Direction guard is facing (0-360)
rotation_speed = 2; // Degrees per frame to rotate vision cone
prev_x = x; // Track previous position to calculate movement direction
prev_y = y;

// Vision cone properties
cone_angle = 20; // Half-angle of cone
cone_length = 200; // Vision range
player_detected = false;

// State machine
state = "PATROL"; // States: PATROL, INVESTIGATE, CHASE

// Pathfinding setup
path = path_add();
grid = noone; // Will be created on first step
grid_initialized = false;

// Waypoint system
my_waypoints = []; // Array of waypoint instances assigned to this guard
current_waypoint_index = 0;
waypoint_reached_distance = 16; // How close to get to waypoint
path_calculated = false; // Track if path to current waypoint is set

// Y-sorting depth
depth = -y;
