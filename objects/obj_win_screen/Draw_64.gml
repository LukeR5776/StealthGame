// Draw semi-transparent overlay
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);
draw_set_color(c_white);

// Check if layout data is valid
if (!variable_struct_exists(self, "panel_layout") || panel_layout == undefined) {
    show_debug_message("ERROR: panel_layout is undefined!");
    draw_text(100, 100, "Error: Layout data missing");
    return;
}

// Draw main panel background
draw_set_color(c_dkgray);
draw_rectangle(panel_layout.left, panel_layout.top,
    panel_layout.left + panel_layout.width,
    panel_layout.top + panel_layout.height, false);

// Draw panel border
draw_set_color(c_white);
draw_rectangle(panel_layout.left, panel_layout.top,
    panel_layout.left + panel_layout.width,
    panel_layout.top + panel_layout.height, true);

// Draw title text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_lime);
draw_text_transformed(
    title_layout.left + title_layout.width / 2,
    title_layout.top + title_layout.height / 2,
    "VICTORY!",
    2, 2, 0
);

// Draw button backgrounds and text
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Button 1: Return to Menu (TODO)
var btn1_center_x = button_menu_layout.left + button_menu_layout.width / 2;
var btn1_center_y = button_menu_layout.top + button_menu_layout.height / 2;
draw_set_color(c_gray);
draw_rectangle(button_menu_layout.left, button_menu_layout.top,
    button_menu_layout.left + button_menu_layout.width,
    button_menu_layout.top + button_menu_layout.height, false);
draw_set_color(c_white);
draw_rectangle(button_menu_layout.left, button_menu_layout.top,
    button_menu_layout.left + button_menu_layout.width,
    button_menu_layout.top + button_menu_layout.height, true);
draw_text(btn1_center_x, btn1_center_y, "Return to Menu (TODO)");

// Button 2: Restart Level (TODO)
var btn2_center_x = button_restart_layout.left + button_restart_layout.width / 2;
var btn2_center_y = button_restart_layout.top + button_restart_layout.height / 2;
draw_set_color(c_gray);
draw_rectangle(button_restart_layout.left, button_restart_layout.top,
    button_restart_layout.left + button_restart_layout.width,
    button_restart_layout.top + button_restart_layout.height, false);
draw_set_color(c_white);
draw_rectangle(button_restart_layout.left, button_restart_layout.top,
    button_restart_layout.left + button_restart_layout.width,
    button_restart_layout.top + button_restart_layout.height, true);
draw_text(btn2_center_x, btn2_center_y, "Restart Level (TODO)");

// Button 3: Back to Editor
var btn3_center_x = button_editor_layout.left + button_editor_layout.width / 2;
var btn3_center_y = button_editor_layout.top + button_editor_layout.height / 2;
draw_set_color(c_gray);
draw_rectangle(button_editor_layout.left, button_editor_layout.top,
    button_editor_layout.left + button_editor_layout.width,
    button_editor_layout.top + button_editor_layout.height, false);
draw_set_color(c_lime);
draw_rectangle(button_editor_layout.left, button_editor_layout.top,
    button_editor_layout.left + button_editor_layout.width,
    button_editor_layout.top + button_editor_layout.height, true);
draw_text(btn3_center_x, btn3_center_y, "Back to Editor");

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
