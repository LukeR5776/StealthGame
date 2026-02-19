image_speed = 0;

// player interaction range
if (instance_exists(obj_player)) {
    var dist_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    if (dist_to_player <= 40) {
        // lockpicking
        if (is_locked) {
            if (keyboard_check(ord("G"))) {
                lockpick_progress += delta_time / 1000000;

                // unlock when complete
                if (lockpick_progress >= lockpick_time_required) {
                    is_locked = false;
                    lockpick_progress = 0;
                }
            }
        } else {
            // open/close with F
            if (keyboard_check_pressed(ord("F"))) {
                var next_is_open = !is_open;

                // sprite for next state
                var next_sprite = sprite_index;
                if (door_direction == 0) {
                    next_sprite = next_is_open ? spr_door_forward_open : spr_door_forward;
                } else if (door_direction == 180) {
                    next_sprite = next_is_open ? spr_door_backward_open : spr_door_backward;
                } else if (door_direction == 90 || door_direction == 270) {
                    next_sprite = next_is_open ? spr_door_vertical_open : spr_door_vertical;
                }

                var current_sprite = sprite_index;

                // prevent door from crushing player
                sprite_index = next_sprite;
                var player_collides = place_meeting(x, y, obj_player);
                sprite_index = current_sprite;

                // apply if safe
                if (!player_collides) {
                    is_open = next_is_open;
                }
            }
        }
    }
}

// update sprite
if (door_direction == 0) {
    sprite_index = is_open ? spr_door_forward_open : spr_door_forward;
    image_xscale = 1;
} else if (door_direction == 180) {
    sprite_index = is_open ? spr_door_backward_open : spr_door_backward;
    image_xscale = 1;
} else if (door_direction == 90) {
    sprite_index = is_open ? spr_door_vertical_open : spr_door_vertical;
    image_xscale = 1;
} else if (door_direction == 270) {
    sprite_index = is_open ? spr_door_vertical_open : spr_door_vertical;
    image_xscale = -1;
}

image_index = 0;
