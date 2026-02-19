// placement preview
if (game_mode == "build") {
var tile_x = mouse_x div tile_w;
var tile_y = mouse_y div tile_h;

if (tile_x >= 0 && tile_x < cell_w && tile_y >= 0 && tile_y < cell_h) {
    var preview_x = tile_x * tile_w + tile_w / 2;
    var preview_y = tile_y * tile_h + tile_h / 2;
    var preview_alpha = 0.3;

    draw_set_alpha(preview_alpha);

    if (current_selection == PLACE_WALL) {
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
        draw_set_alpha(0.15);
        scr_draw_camera_fov(preview_x, preview_y, camera_placement_direction, 30, 200, c_lime, 1.0);
    }
    else if (current_selection == PLACE_GUARD) {
        draw_sprite(spr_guard, 0, preview_x, preview_y);
        draw_set_alpha(0.15);
        scr_draw_camera_fov(preview_x, preview_y, guard_placement_direction, 20, 200, c_lime, 1.0);
    }
    else if (current_selection == PLACE_WAYPOINT) {
        draw_set_alpha(preview_alpha);
        draw_set_color(c_yellow);
        draw_circle(preview_x, preview_y, 8, false);

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
    else if (current_selection == PLACE_DOOR) {
        draw_set_alpha(preview_alpha);

        var preview_sprite = spr_door_forward;
        var preview_xscale = 1;

        if (door_placement_direction == 0) {
            preview_sprite = spr_door_forward;
            preview_xscale = 1;
        } else if (door_placement_direction == 180) {
            preview_sprite = spr_door_backward;
            preview_xscale = 1;
        } else if (door_placement_direction == 90) {
            preview_sprite = spr_door_vertical;
            preview_xscale = 1;
        } else if (door_placement_direction == 270) {
            preview_sprite = spr_door_vertical;
            preview_xscale = -1;
        }

        draw_sprite_ext(preview_sprite, 0, preview_x, preview_y, preview_xscale, 1, 0, c_white, preview_alpha);
    }
    else if (current_selection == PLACE_EXTRACTION) {
        draw_set_alpha(preview_alpha);
        draw_sprite(spr_extraction, 0, preview_x, preview_y);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
}
