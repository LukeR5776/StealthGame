// Draw the door sprite
draw_self();

// Draw "Press F" prompt when player is nearby
if (instance_exists(obj_player)) {
    var dist_to_player = point_distance(x, y, obj_player.x, obj_player.y);
    if (dist_to_player <= 40) {
        // Draw prompt text above door
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_text(x + 16, y - 5, "[F]");

        // Reset draw settings
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
