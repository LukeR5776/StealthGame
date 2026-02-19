sweep_timer += 1 / room_speed;

cam_x = x+16;
cam_y = y+16;

// sine wave sweep
var sweep_speed = 0.5;
var normalized_sweep = sin(sweep_timer * sweep_speed);

cone_direction = start_direction + (normalized_sweep * sweep_range);

player_detected = false;

// detect unconscious guards
with (obj_guard) {
    if (is_unconscious) {
        var guard_check_points = [
            [(bbox_left + bbox_right) / 2, (bbox_top + bbox_bottom) / 2],
            [bbox_left, bbox_top],
            [bbox_right, bbox_top],
            [bbox_left, bbox_bottom],
            [bbox_right, bbox_bottom]
        ];

        for (var i = 0; i < 5; i++) {
            var check_x = guard_check_points[i][0];
            var check_y = guard_check_points[i][1];

            var dist_to_point = point_distance(other.cam_x, other.cam_y, check_x, check_y);
            if (dist_to_point <= other.cone_length) {
                var angle_to_point = point_direction(other.cam_x, other.cam_y, check_x, check_y);
                var angle_diff = angle_difference(other.cone_direction, angle_to_point);

                if (abs(angle_diff) <= other.cone_angle) {
                    var collision = collision_line(other.cam_x, other.cam_y, check_x, check_y, obj_vision_blocker, false, true);

                    if (collision == noone) {
                        other.player_detected = true;
                        if (other.alarm[0] <= 0) {
                            other.alarm[0] = 40;
                        }
                        break;
                    }
                }
            }
        }

        if (other.player_detected) {
            break;
        }
    }
}

if (instance_exists(obj_player)) {
    // multi-point check for better detection
    var check_points = [
        [(obj_player.bbox_left + obj_player.bbox_right) / 2, (obj_player.bbox_top + obj_player.bbox_bottom) / 2],
        [obj_player.bbox_left, obj_player.bbox_top],
        [obj_player.bbox_right, obj_player.bbox_top],
        [obj_player.bbox_left, obj_player.bbox_bottom],
        [obj_player.bbox_right, obj_player.bbox_bottom]
    ];

    for (var i = 0; i < 5; i++) {
        var check_x = check_points[i][0];
        var check_y = check_points[i][1];

        var dist_to_point = point_distance(cam_x, cam_y, check_x, check_y);
        if (dist_to_point <= cone_length) {
            var angle_to_point = point_direction(cam_x, cam_y, check_x, check_y);
            var angle_diff = angle_difference(cone_direction, angle_to_point);

            if (abs(angle_diff) <= cone_angle) {
                var collision = collision_line(cam_x, cam_y, check_x, check_y, obj_vision_blocker, false, true);

                if (collision == noone) {
                    player_detected = true;
				if alarm[0] <= 0 {
				alarm[0] = 40;
				}
                    break;
                }
            }
        }
    }
}
