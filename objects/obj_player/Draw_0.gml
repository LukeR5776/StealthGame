draw_self();

// check detection status
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

// show knockout prompt when unseen
if (!is_detected) {
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
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_text(nearest_guard.x, nearest_guard.y - 10, "[F] Knockout");

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
