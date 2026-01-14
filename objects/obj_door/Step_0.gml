// Stop sprite animation (prevent flickering)
image_speed = 0;

// Check if player is nearby and can interact
if (instance_exists(obj_player)) {
    var dist_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    if (dist_to_player <= 40) { // Interaction range (match draw prompt)
        // If player presses F key, toggle door
        if (keyboard_check_pressed(ord("F"))) {
            // Determine what the next state would be
            var next_is_open = !is_open;

            // Determine what sprite the door would use in the next state
            var next_sprite = sprite_index; // Default to current
            if (door_direction == 0) {
                next_sprite = next_is_open ? spr_door_forward_open : spr_door_forward;
            } else if (door_direction == 180) {
                next_sprite = next_is_open ? spr_door_backward_open : spr_door_backward;
            } else if (door_direction == 90 || door_direction == 270) {
                next_sprite = next_is_open ? spr_door_vertical_open : spr_door_vertical;
            }

            // Store current sprite
            var current_sprite = sprite_index;

            // Temporarily set to next sprite to check collision
            sprite_index = next_sprite;

            // Check if player would collide with the door in this state
            var player_collides = place_meeting(x, y, obj_player);

            // Restore current sprite
            sprite_index = current_sprite;

            // Only toggle if player won't collide with the door in its new state
            if (!player_collides) {
                is_open = next_is_open;
            }

            // Toggle collision
            //solid = !is_open;
        }
    }
}

// Set sprite based on door direction and open/closed state
if (door_direction == 0) {
    // Up - forward facing door
    sprite_index = is_open ? spr_door_forward_open : spr_door_forward;
    image_xscale = 1;
} else if (door_direction == 180) {
    // Down - backward facing door
    sprite_index = is_open ? spr_door_backward_open : spr_door_backward;
    image_xscale = 1;
} else if (door_direction == 90) {
    // Right - vertical door, no flip
    sprite_index = is_open ? spr_door_vertical_open : spr_door_vertical;
    image_xscale = 1;
} else if (door_direction == 270) {
    // Left - vertical door, horizontal flip
    sprite_index = is_open ? spr_door_vertical_open : spr_door_vertical;
    image_xscale = -1;
}

// No need to set image_index - each sprite is single-frame now
image_index = 0;

// Update depth for Y-sorting
//depth = -y;
