// Draw line to next waypoint in patrol route
if (guard_id != noone && instance_exists(guard_id)) {
    // Find the next waypoint in sequence
    var next_waypoint = noone;

    with (obj_waypoint) {
        if (guard_id == other.guard_id && waypoint_id == other.waypoint_id + 1) {
            next_waypoint = id;
        }
    }

    // If no next waypoint found, connect back to waypoint 0 (loop)
    if (next_waypoint == noone) {
        with (obj_waypoint) {
            if (guard_id == other.guard_id && waypoint_id == 0) {
                next_waypoint = id;
            }
        }
    }

    // Draw line to next waypoint
    if (next_waypoint != noone && instance_exists(next_waypoint)) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_line_width(x, y, next_waypoint.x, next_waypoint.y, 2);
    }
}

// Draw waypoint marker (small circle)
draw_set_color(c_yellow);
draw_set_alpha(0.7);
draw_circle(x, y, 8, false);

// Draw waypoint ID number
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, string(waypoint_id));

// Reset draw settings
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
