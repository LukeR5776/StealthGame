// Draw cursor preview for current selection
var tile_x = mouse_x div tile_w;
var tile_y = mouse_y div tile_h;

// Only draw if mouse is within grid bounds
if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {
    var preview_x = tile_x * tile_w + tile_w / 2;
    var preview_y = tile_y * tile_h + tile_h / 2;
    var preview_alpha = 0.3;

    draw_set_alpha(preview_alpha);

    // Draw appropriate preview based on current selection
    if (current_selection == PLACE_WALL) {
        // Draw wall preview at tile corner (walls are top-left aligned)
        draw_sprite(spr_wall, 0, tile_x * tile_w, tile_y * tile_h);
    }
    else if (current_selection == PLACE_PLAYER_SPAWN) {
        draw_sprite(spr_player_spawn, 0, preview_x, preview_y);
    }
    else if (current_selection == PLACE_GOAL) {
        draw_sprite(spr_goal, 0, preview_x, preview_y);
    }
    else if (current_selection == PLACE_SECURITY_CAM) {
        draw_sprite(spr_security_cam, 0, preview_x, preview_y);
        // Draw preview of camera vision cone direction
        draw_set_alpha(0.15);
        scr_draw_camera_fov(preview_x, preview_y, camera_placement_direction, 30, 200, c_lime, 1.0);
    }
    else if (current_selection == PLACE_GUARD) {
        draw_sprite(spr_guard, 0, preview_x, preview_y);
        // Draw preview of guard vision cone direction
        draw_set_alpha(0.15);
        scr_draw_camera_fov(preview_x, preview_y, guard_placement_direction, 20, 200, c_lime, 1.0);
    }
    else if (current_selection == PLACE_WAYPOINT) {
        // Draw waypoint preview (circle)
        draw_set_alpha(preview_alpha);
        draw_set_color(c_yellow);
        draw_circle(preview_x, preview_y, 8, false);

        // Draw waypoint ID number
        draw_set_alpha(0.5);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (selected_guard_id != noone) {
            draw_text(preview_x, preview_y, string(next_waypoint_id));
        } else {
            draw_text(preview_x, preview_y, "?");
        }
    }

    // Reset draw settings
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
