// Stop sprite animation (prevent flickering)
image_speed = 0;

// Check if player is nearby and can interact
if (instance_exists(obj_player)) {
    var dist_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    if (dist_to_player <= 40) { // Interaction range (match draw prompt)
        // If player presses F key, toggle door
        if (keyboard_check_pressed(ord("F"))) {
            is_open = !is_open;

            // Toggle collision
            //solid = !is_open;
        }
    }
}

// Set sprite and flip based on door direction
if (door_direction == 0) {
    // Up - forward facing door
    sprite_index = spr_door_forward;
    image_xscale = 1;
} else if (door_direction == 180) {
    // Down - backward facing door
    sprite_index = spr_door_backward;
    image_xscale = 1;
} else if (door_direction == 90) {
    // Right - vertical door, no flip
    sprite_index = spr_door_vertical;
    image_xscale = 1;
} else if (door_direction == 270) {
    // Left - vertical door, horizontal flip
    sprite_index = spr_door_vertical;
    image_xscale = -1;
}

// Update frame based on open/closed state
// All sprites use same convention: frame 0 = closed, frame 1 = open
image_index = is_open ? 1 : 0;

// Update depth for Y-sorting
//depth = -y;
