// Draw the sprite
draw_self();

// Draw the vision cone using visibility polygon algorithm
var vision_color = player_detected ? c_red : c_lime;
var vision_alpha = player_detected ? 0.3 : 0.2;

scr_draw_camera_fov(cam_x, cam_y, cone_direction, cone_angle, cone_length, vision_color, vision_alpha);
