// Get input for movement
var move_x = 0;
var move_y = 0;

if (keyboard_check(vk_right) || keyboard_check(ord("D"))) move_x += 1;
if (keyboard_check(vk_left) || keyboard_check(ord("A"))) move_x -= 1;
if (keyboard_check(vk_down) || keyboard_check(ord("S"))) move_y += 1;
if (keyboard_check(vk_up) || keyboard_check(ord("W"))) move_y -= 1;

// Move horizontally with collision
if (move_x != 0) {
    var move_amount = move_x * move_speed;

    // Check if moving would collide with any solid object
    if (place_free(x + move_amount, y)) {
        x += move_amount;
    } else {
        // Move pixel by pixel
        for (var i = 1; i <= abs(move_amount); i++) {
            if (place_free(x + sign(move_x), y)) {
                x += sign(move_x);
            } else {
                break;
            }
        }
    }
}

// Move vertically with collision
if (move_y != 0) {
    var move_amount = move_y * move_speed;

    // Check if moving would collide with any solid object
    if (place_free(x, y + move_amount)) {
        y += move_amount;
    } else {
        // Move pixel by pixel
        for (var i = 1; i <= abs(move_amount); i++) {
            if (place_free(x, y + sign(move_y))) {
                y += sign(move_y);
            } else {
                break;
            }
        }
    }
}

//Update depth based on Y position
depth = -y;