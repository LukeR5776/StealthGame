var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_alpha(0.9);
draw_rectangle_color(0, 0, gui_w, gui_h, color_bg_dark, color_bg_dark, color_bg_dark, color_bg_dark, false);
draw_set_alpha(1);

var margin = 50;
panel_x = margin;
panel_y = margin;
panel_w = gui_w - (margin * 2);
panel_h = gui_h - (margin * 2);

draw_rectangle_color(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h,
    color_panel_bg, color_panel_bg, color_panel_bg, color_panel_bg, false);

draw_rectangle_color(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h,
    color_border, color_border, color_border, color_border, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(panel_x + panel_w / 2, panel_y + 20, "CAMPAIGN MISSIONS");

var content_y = panel_y + 70;
var content_h = panel_h - 140;

list_x = panel_x + 20;
list_y = content_y;
list_w = (panel_w * 0.4) - 30;
list_h = content_h;

desc_x = list_x + list_w + 20;
desc_y = content_y;
desc_w = (panel_w * 0.6) - 30;
desc_h = content_h;

draw_line_width_color(desc_x - 10, content_y, desc_x - 10, content_y + content_h, 2, color_border, color_border);

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

level_slots = [];

draw_set_halign(fa_left);
draw_set_valign(fa_top);

for (var i = 0; i < array_length(campaign_levels); i++) {
    var level_data = campaign_levels[i];
    var level_num = level_data.level_num;

    var slot_y = list_y + (i * slot_height);
    var unlocked = is_level_unlocked(level_num);
    var completed = array_contains(campaign_progress.completed_levels, level_num);
    var selected = (selected_level == level_num);

    var slot = {
        left: list_x,
        top: slot_y,
        width: list_w,
        height: slot_height - 10
    };
    array_push(level_slots, slot);

    var slot_color = color_slot_locked;
    if (unlocked) {
        if (selected) {
            slot_color = color_slot_selected;
        } else if (completed) {
            slot_color = color_slot_completed;
        } else {
            slot_color = color_slot_unlocked;
        }
    }

    draw_rectangle_color(slot.left, slot.top, slot.left + slot.width, slot.top + slot.height,
        slot_color, slot_color, slot_color, slot_color, false);

    var border_color = selected ? c_white : color_border;
    draw_rectangle_color(slot.left, slot.top, slot.left + slot.width, slot.top + slot.height,
        border_color, border_color, border_color, border_color, true);

    draw_set_color(c_white);
    draw_text(slot.left + 15, slot.top + 10, "LEVEL " + string(level_num));

    if (unlocked) {
        draw_set_color(c_white);
        draw_text(slot.left + 15, slot.top + 35, level_data.title);
    } else {
        draw_set_color(color_text_dim);
        draw_text(slot.left + 15, slot.top + 35, "[LOCKED]");
    }

    if (completed) {
        draw_set_color(c_lime);
        draw_text(slot.left + slot.width - 40, slot.top + 10, "[✓]");
    }
}

if (selected_level > 0 && selected_level <= array_length(campaign_levels)) {
    var level = get_campaign_level_by_num(selected_level);

    if (level != undefined) {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);

        draw_text_ext(desc_x, desc_y, level.title, -1, desc_w);

        draw_set_color(color_text_dim);
        draw_text_ext(desc_x, desc_y + 50, level.description, -1, desc_w);

        draw_set_color(c_white);
        draw_text(desc_x, desc_y + 120, "OBJECTIVES:");

        draw_set_color(color_text_dim);
        draw_text_ext(desc_x, desc_y + 150, level.objectives, -1, desc_w);
    }
}

var button_y = panel_y + panel_h - 70;
var button_h = 50;

var play_button_w = 200;
play_button.left = panel_x + panel_w - play_button_w - 120;
play_button.top = button_y;
play_button.width = play_button_w;
play_button.height = button_h;

var can_play = is_level_unlocked(selected_level);
var hover_play = point_in_rectangle(mx, my, play_button.left, play_button.top,
    play_button.left + play_button.width, play_button.top + play_button.height);

var play_color = can_play ? (hover_play ? color_button_hover : color_button_normal) : color_button_disabled;

draw_rectangle_color(play_button.left, play_button.top,
    play_button.left + play_button.width, play_button.top + play_button.height,
    play_color, play_color, play_color, play_color, false);

draw_rectangle_color(play_button.left, play_button.top,
    play_button.left + play_button.width, play_button.top + play_button.height,
    color_border, color_border, color_border, color_border, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(can_play ? c_white : color_text_dim);
draw_text(play_button.left + play_button.width / 2, play_button.top + play_button.height / 2, "PLAY MISSION");

var back_button_w = 150;
back_button.left = panel_x + 20;
back_button.top = button_y;
back_button.width = back_button_w;
back_button.height = button_h;

var hover_back = point_in_rectangle(mx, my, back_button.left, back_button.top,
    back_button.left + back_button.width, back_button.top + back_button.height);

var back_color = hover_back ? color_button_hover : color_slot_unlocked;

draw_rectangle_color(back_button.left, back_button.top,
    back_button.left + back_button.width, back_button.top + back_button.height,
    back_color, back_color, back_color, back_color, false);

draw_rectangle_color(back_button.left, back_button.top,
    back_button.left + back_button.width, back_button.top + back_button.height,
    color_border, color_border, color_border, color_border, true);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(back_button.left + back_button.width / 2, back_button.top + back_button.height / 2, "BACK");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
