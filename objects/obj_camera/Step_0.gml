var in_build_mode = false;
if (instance_exists(obj_controller)) {
    in_build_mode = (obj_controller.game_mode == "build");
}

if (in_build_mode) {
    // WASD pan in build mode
    var move_x = 0;
    var move_y = 0;

    if (keyboard_check(ord("W"))) move_y -= 1;
    if (keyboard_check(ord("S"))) move_y += 1;
    if (keyboard_check(ord("A"))) move_x -= 1;
    if (keyboard_check(ord("D"))) move_x += 1;

    x += move_x * build_cam_speed;
    y += move_y * build_cam_speed;

    x = clamp(x, cam_width / 2, room_width - cam_width / 2);
    y = clamp(y, cam_height / 2, room_height - cam_height / 2);
} else {
    // follow player
    if (instance_exists(target)) {
        x = lerp(x, target.x, follow_speed);
        y = lerp(y, target.y, follow_speed);
    }
}

var cam_x = x - (cam_width / 2);
var cam_y = y - (cam_height / 2);

cam_x = clamp(cam_x, 0, room_width - cam_width);
cam_y = clamp(cam_y, 0, room_height - cam_height);

camera_set_view_pos(cam, cam_x, cam_y);
