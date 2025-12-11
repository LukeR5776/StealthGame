// Draw the guard sprite
draw_self();

// Draw the vision cone using visibility polygon algorithm
// Color based on state and detection
var vision_color = c_lime; // Default green for patrol
var vision_alpha = 0.2;

if (player_detected) {
    vision_color = c_red;
    vision_alpha = 0.3;
} else if (state == "INVESTIGATE") {
    vision_color = c_yellow;
    vision_alpha = 0.25;
} else if (state == "CHASE") {
    vision_color = c_red;
    vision_alpha = 0.35;
}

// Use the same FOV drawing function as security cameras
scr_draw_camera_fov(x, y, facing_direction, cone_angle, cone_length, vision_color, vision_alpha);
