// build mode only
if (instance_exists(obj_controller) && obj_controller.game_mode == "build") {

// path visualization
if (guard_id != noone && instance_exists(guard_id)) {
    var next_waypoint = noone;

    with (obj_waypoint) {
        if (guard_id == other.guard_id && waypoint_id == other.waypoint_id + 1) {
            next_waypoint = id;
        }
    }

    // loop to start
    if (next_waypoint == noone) {
        with (obj_waypoint) {
            if (guard_id == other.guard_id && waypoint_id == 0) {
                next_waypoint = id;
            }
        }
    }

    if (next_waypoint != noone && instance_exists(next_waypoint)) {
        draw_set_color(c_yellow);
        draw_set_alpha(0.3);
        draw_line_width(x, y, next_waypoint.x, next_waypoint.y, 2);
    }
}

draw_set_color(c_yellow);
draw_set_alpha(0.7);
draw_circle(x, y, 8, false);

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, string(waypoint_id));

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

}
