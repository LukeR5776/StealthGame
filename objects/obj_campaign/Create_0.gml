selected_level = 1;
campaign_levels = get_campaign_levels();
campaign_progress = get_campaign_progress();

layout_calculated = false;

level_slots = [];
play_button = { left: 0, top: 0, width: 0, height: 0 };
back_button = { left: 0, top: 0, width: 0, height: 0 };

panel_x = 0;
panel_y = 0;
panel_w = 0;
panel_h = 0;

list_x = 0;
list_y = 0;
list_w = 0;
list_h = 0;
slot_height = 80;

desc_x = 0;
desc_y = 0;
desc_w = 0;
desc_h = 0;

// Colors
color_bg_dark = c_black;
color_panel_bg = c_dkgray;
color_border = c_white;
color_slot_unlocked = #2c3e50;
color_slot_locked = #1a1a1a;
color_slot_selected = #27ae60;
color_slot_completed = #f39c12;
color_button_normal = #27ae60;
color_button_hover = #2ecc71;
color_button_disabled = #555555;
color_text = c_white;
color_text_dim = c_gray;

show_debug_message("Campaign menu created. Selected level: " + string(selected_level));
