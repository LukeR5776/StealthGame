// Vision cone properties
cone_direction = 0; // Current rotation angle
cone_angle = 30; // Half-angle of cone (total width = 60 degrees)
cone_length = 250; // How far the camera can see
rotation_speed = 1; // Degrees per step

// Sweep behavior
start_direction = cone_direction; // Store initial facing direction
sweep_range = 90; // Sweep ±90 degrees from start direction
sweep_direction = 1; // 1 = sweeping right, -1 = sweeping left
sweep_timer = 0; // Independent timer for this camera instance

// Detection state
player_detected = false;
