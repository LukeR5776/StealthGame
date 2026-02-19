// input
var move_x = 0;
var move_y = 0;

if (keyboard_check(vk_right) || keyboard_check(ord("D"))) move_x += 1;
if (keyboard_check(vk_left) || keyboard_check(ord("A"))) move_x -= 1;
if (keyboard_check(vk_down) || keyboard_check(ord("S"))) move_y += 1;
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) move_y -= 1;

// horizontal collision
if (move_x != 0) {
    var move_amount = move_x * move_speed;

    if (place_free(x + move_amount, y)) {
        x += move_amount;
    } else {
        // pixel-perfect sliding
        for (var i = 1; i <= abs(move_amount); i++) {
            if (place_free(x + sign(move_x), y)) {
                x += sign(move_x);
            } else {
                break;
            }
        }
    }
}

// vertical collision
if (move_y != 0) {
    var move_amount = move_y * move_speed;

    if (place_free(x, y + move_amount)) {
        y += move_amount;
    } else {
        // pixel-perfect sliding
        for (var i = 1; i <= abs(move_amount); i++) {
            if (place_free(x, y + sign(move_y))) {
                y += sign(move_y);
            } else {
                break;
            }
        }
    }
}

// knockout
if (keyboard_check_pressed(ord("F"))) {
    // can't knockout while detected
    var is_detected = false;
    with (obj_security_cam) {
        if (player_detected) {
            is_detected = true;
            break;
        }
    }
    with (obj_guard) {
        if (player_detected) {
            is_detected = true;
            break;
        }
    }

    if (!is_detected) {
        // find guard within 32px
        var nearest_guard = noone;
        var nearest_dist = 32;

        with (obj_guard) {
            if (!is_unconscious) {
                var dist = point_distance(x, y, other.x, other.y);
                if (dist <= nearest_dist) {
                    nearest_guard = id;
                    nearest_dist = dist;
                }
            }
        }

        if (nearest_guard != noone) {
            nearest_guard.is_unconscious = true;
            with (nearest_guard) {
                path_end();
            }
        }
    }
}

// y-sorting
depth = -y;