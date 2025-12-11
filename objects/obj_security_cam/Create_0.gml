// Vision cone properties
cone_direction = 0; // Current rotation angle
cone_angle = 20; // Half-angle of cone (total width = 60 degrees)
cone_length = 200; // How far the camera can see
rotation_speed = 1; // Degrees per step

// Sweep behavior
start_direction = cone_direction; // Store initial facing direction
sweep_range = 60; // Sweep ±90 degrees from start direction
sweep_direction = 1; // 1 = sweeping right, -1 = sweeping left
sweep_timer = 0; // Independent timer for this camera instance

cam_x = x+16; //Offset
cam_y = y+16; //Offset

// Detection state
player_detected = false;
