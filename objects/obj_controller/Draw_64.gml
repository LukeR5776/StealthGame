draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var mode_text = game_mode == "build" ? "BUILD MODE" : "PLAY MODE";
var mode_color = game_mode == "build" ? c_yellow : c_lime;
draw_set_color(mode_color);
draw_text(20, 90, mode_text + " (P to toggle)");
draw_set_color(c_white);

// play mode HUD
if (game_mode == "play") {
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

    var status_text = is_detected ? "Status: DETECTED!" : "Status: UNSEEN";
    var status_color = is_detected ? c_red : c_lime;
    draw_set_color(status_color);
    draw_text(20, 40, status_text);
    draw_set_color(c_white);

    draw_text(20, 60, string(goals_collected) + "/" + string(total_goals) + " Collected");
}

// build mode HUD
if (game_mode == "build") {

if (mode_switch_error != "") {
    draw_set_color(c_red);
    draw_text(20, 110, mode_switch_error);
    draw_set_color(c_white);
}

// carousel
var gui_w = display_get_gui_width();
var carousel_center_x = gui_w / 2;
var bar_height = 70;
var bar_y = carousel_y - bar_height / 2;

draw_set_alpha(0.7);
draw_set_color(c_dkgray);
draw_rectangle(0, bar_y, gui_w, bar_y + bar_height, false);
draw_set_alpha(1.0);

draw_set_color(c_white);
draw_line(0, bar_y, gui_w, bar_y);
draw_line(0, bar_y + bar_height, gui_w, bar_y + bar_height);

for (var i = 0; i < carousel_item_count; i++) {
    var item = carousel_items[i];

    var distance_from_center = i - carousel_visual_offset;
    var abs_distance = abs(distance_from_center);

    if (abs_distance > carousel_visible_distance) {
        continue;
    }

    var item_x = carousel_center_x + (distance_from_center * carousel_item_spacing);
    var item_y = carousel_y;

    var scale_factor = 1.0 - (abs_distance * 0.25);
    scale_factor = max(scale_factor, 0.5);
    var item_scale = (abs_distance < 0.5) ? carousel_selected_scale : carousel_unselected_scale;
    item_scale *= scale_factor;

    var item_alpha = 1.0 - (abs_distance * 0.3);
    item_alpha = clamp(item_alpha, 0.2, 1.0);

    if (abs_distance < 0.5) {
        item_alpha = 1.0;
    }

    var box_size = 32 * item_scale + 8;
    var box_half = box_size / 2;

    draw_set_alpha(item_alpha * 0.8);
    draw_set_color(c_dkgray);
    draw_rectangle(item_x - box_half, item_y - box_half,
                   item_x + box_half, item_y + box_half, false);

    // green border for selected
    draw_set_alpha(item_alpha);
    if (abs_distance < 0.5) {
        draw_set_color(c_lime);
    } else {
        draw_set_color(c_white);
    }
    draw_rectangle(item_x - box_half, item_y - box_half,
                   item_x + box_half, item_y + box_half, true);

    if (item.sprite == -1) {
        // waypoint has no sprite, draw circle
        var wp_radius = 10 * item_scale;
        draw_set_color(c_yellow);
        draw_circle(item_x, item_y, wp_radius, false);
        draw_set_color(c_white);
        draw_circle(item_x, item_y, wp_radius, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text(item_x, item_y, "W");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        var sprite_draw_x = item_x;
        var sprite_draw_y = item_y;

        // top-left origin offset
        if (!item.origin_centered) {
            sprite_draw_x = item_x - (16 * item_scale);
            sprite_draw_y = item_y - (16 * item_scale);
        }

        draw_sprite_ext(item.sprite, 0, sprite_draw_x, sprite_draw_y,
                        item_scale, item_scale, 0, c_white, item_alpha);
    }

    // name label for selected
    if (abs_distance < 0.5) {
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text(item_x, item_y + box_half + 5, item.name);
        draw_set_halign(fa_left);
    }
}

// Reset draw state after carousel
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// ===== END CAROUSEL UI =====

// ===== PROPERTIES PANEL =====
// Only show for objects with configurable properties
var has_properties = (current_selection == PLACE_SECURITY_CAM) ||
                     (current_selection == PLACE_GUARD) ||
                     (current_selection == PLACE_DOOR) ||
                     (current_selection == PLACE_WAYPOINT);

if (has_properties) {
    var row_count = 0;
    if (current_selection == PLACE_SECURITY_CAM) row_count = 1;
    if (current_selection == PLACE_GUARD) row_count = 1;
    if (current_selection == PLACE_DOOR) row_count = 2;
    if (current_selection == PLACE_WAYPOINT) row_count = 1;

    var panel_height = props_panel_padding * 2 + row_count * props_row_height + 20;
    var panel_x1 = props_panel_x;
    var panel_y1 = props_panel_y;
    var panel_x2 = props_panel_x + props_panel_width;
    var panel_y2 = props_panel_y + panel_height;

    // block placement when hovering panel
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    mouse_over_props_panel = point_in_rectangle(mx, my, panel_x1, panel_y1, panel_x2, panel_y2);

    draw_set_alpha(0.85);
    draw_set_color(c_dkgray);
    draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, false);
    draw_set_alpha(1.0);

    draw_set_color(c_white);
    draw_rectangle(panel_x1, panel_y1, panel_x2, panel_y2, true);

    draw_set_color(c_lime);
    draw_text(panel_x1 + props_panel_padding, panel_y1 + props_panel_padding, "Properties");
    draw_set_color(c_white);

    var content_y = panel_y1 + props_panel_padding + 20;

    if (current_selection == PLACE_SECURITY_CAM) {
        draw_text(panel_x1 + props_panel_padding, content_y, "Rotation: " + string(camera_placement_direction) + "°");
        draw_set_color(c_gray);
        draw_text(panel_x1 + props_panel_padding, content_y + 12, "(R/T to change)");
        draw_set_color(c_white);
    }

    if (current_selection == PLACE_GUARD) {
        draw_text(panel_x1 + props_panel_padding, content_y, "Rotation: " + string(guard_placement_direction) + "°");
        draw_set_color(c_gray);
        draw_text(panel_x1 + props_panel_padding, content_y + 12, "(R/T to change)");
        draw_set_color(c_white);
    }

    if (current_selection == PLACE_DOOR) {
        draw_text(panel_x1 + props_panel_padding, content_y, "Rotation: " + string(door_placement_direction) + "°");
        draw_set_color(c_gray);
        draw_text(panel_x1 + props_panel_padding, content_y + 12, "(R/T to change)");
        draw_set_color(c_white);
        content_y += props_row_height;

        // locked checkbox
        var checkbox_x = panel_x1 + props_panel_padding;
        var checkbox_y = content_y + 2;

        // stored for click detection in Step
        props_checkbox_x1 = checkbox_x;
        props_checkbox_y1 = checkbox_y;
        props_checkbox_x2 = checkbox_x + props_checkbox_size;
        props_checkbox_y2 = checkbox_y + props_checkbox_size;

        draw_set_color(c_black);
        draw_rectangle(checkbox_x, checkbox_y, checkbox_x + props_checkbox_size, checkbox_y + props_checkbox_size, false);

        var checkbox_hovered = point_in_rectangle(mx, my, checkbox_x - 2, checkbox_y - 2,
                                                   checkbox_x + props_checkbox_size + 2, checkbox_y + props_checkbox_size + 2);
        if (checkbox_hovered) {
            draw_set_color(c_lime);
        } else {
            draw_set_color(c_white);
        }
        draw_rectangle(checkbox_x, checkbox_y, checkbox_x + props_checkbox_size, checkbox_y + props_checkbox_size, true);

        if (door_placement_locked) {
            draw_set_color(c_lime);
            draw_line_width(checkbox_x + 3, checkbox_y + 8, checkbox_x + 6, checkbox_y + 12, 2);
            draw_line_width(checkbox_x + 6, checkbox_y + 12, checkbox_x + 13, checkbox_y + 4, 2);
        }

        draw_set_color(c_white);
        draw_text(checkbox_x + props_checkbox_size + 6, content_y + 2, "Locked");
    }

    // Waypoint properties
    if (current_selection == PLACE_WAYPOINT) {
        if (selected_guard_id != noone && instance_exists(selected_guard_id)) {
            draw_set_color(c_lime);
            draw_text(panel_x1 + props_panel_padding, content_y, "Guard #" + string(selected_guard_number));
            draw_set_color(c_gray);
            draw_text(panel_x1 + props_panel_padding, content_y + 12, "(1-9 to change)");
        } else {
            draw_set_color(c_yellow);
            draw_text(panel_x1 + props_panel_padding, content_y, "No guard");
            draw_set_color(c_gray);
            draw_text(panel_x1 + props_panel_padding, content_y + 12, "(Press 1-9)");
        }
        draw_set_color(c_white);
    }
} else {
    mouse_over_props_panel = false;
}

draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
