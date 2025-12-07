// Follow target if exists
if (instance_exists(target)) {
    // Smoothly interpolate camera position toward target
    x = lerp(x, target.x, follow_speed);
    y = lerp(y, target.y, follow_speed);
}

// Center camera on its position
var cam_x = x - (cam_width / 2);
var cam_y = y - (cam_height / 2);

//Clamp camera to room boundaries
cam_x = clamp(cam_x, 0, room_width - cam_width);
cam_y = clamp(cam_y, 0, room_height - cam_height);

// Apply camera position
camera_set_view_pos(cam, cam_x, cam_y);
