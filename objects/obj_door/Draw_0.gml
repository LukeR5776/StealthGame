draw_self();

// build mode lock indicator
if (instance_exists(obj_controller) && obj_controller.game_mode == "build" && is_locked) {
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(x + 16, y + 16, "LOCKED");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

if (instance_exists(obj_player)) {
    var dist_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    if (dist_to_player <= 40) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);

        if (is_locked) {
            draw_set_color(c_red);
            draw_text(x + 16, y - 5, "[LOCKED]");

            // lockpick progress
            if (keyboard_check(ord("G"))) {
                draw_set_color(c_white);
                draw_text(x + 16, y - 20, "[G] Lockpicking...");

                // progress bar
                var bar_width = 40;
                var bar_height = 6;
                var bar_x = x + 16 - bar_width / 2;
                var bar_y = y - 35;

                draw_set_color(c_dkgray);
                draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);

                var progress_percent = lockpick_progress / lockpick_time_required;
                draw_set_color(c_lime);
                draw_rectangle(bar_x, bar_y, bar_x + (bar_width * progress_percent), bar_y + bar_height, false);

                draw_set_color(c_white);
                draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true);
            }
        } else {
            draw_set_color(c_white);
            draw_text(x + 16, y - 5, "[F]");
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
