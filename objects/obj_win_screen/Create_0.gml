// Pause the game
if (instance_exists(obj_game_manager)) {
    obj_game_manager.game_paused = true;
}

// Get the UI layer's root flex panel node
ui_layer_root = layer_get_flexpanel_node("UI_Layer");

// Create flex panel layout programmatically
// Main container - centered panel
win_panel = flexpanel_create_node();
flexpanel_node_style_set_width(win_panel, 500, flexpanel_unit.point);
flexpanel_node_style_set_height(win_panel, 400, flexpanel_unit.point);
flexpanel_node_style_set_justify_content(win_panel, flexpanel_justify.center);
flexpanel_node_style_set_align_items(win_panel, flexpanel_align.center);
flexpanel_node_style_set_flex_direction(win_panel, flexpanel_flex_direction.column);
flexpanel_node_style_set_padding(win_panel, flexpanel_edge.all_edges, 40);
flexpanel_node_style_set_gap(win_panel, flexpanel_gutter.all_gutters, 20);

// Title area
title_node = flexpanel_create_node();
flexpanel_node_style_set_height(title_node, 80, flexpanel_unit.point);
flexpanel_node_style_set_width(title_node, 100, flexpanel_unit.percent);
flexpanel_node_style_set_justify_content(title_node, flexpanel_justify.center);
flexpanel_node_style_set_align_items(title_node, flexpanel_align.center);

// Button container
button_container = flexpanel_create_node();
flexpanel_node_style_set_width(button_container, 100, flexpanel_unit.percent);
flexpanel_node_style_set_flex_direction(button_container, flexpanel_flex_direction.column);
flexpanel_node_style_set_gap(button_container, flexpanel_gutter.all_gutters, 15);
flexpanel_node_style_set_align_items(button_container, flexpanel_align.center);

// Three button nodes
button_menu = flexpanel_create_node();
flexpanel_node_style_set_width(button_menu, 300, flexpanel_unit.point);
flexpanel_node_style_set_height(button_menu, 60, flexpanel_unit.point);

button_restart = flexpanel_create_node();
flexpanel_node_style_set_width(button_restart, 300, flexpanel_unit.point);
flexpanel_node_style_set_height(button_restart, 60, flexpanel_unit.point);

button_editor = flexpanel_create_node();
flexpanel_node_style_set_width(button_editor, 300, flexpanel_unit.point);
flexpanel_node_style_set_height(button_editor, 60, flexpanel_unit.point);

// Build the tree
flexpanel_node_insert_child(button_container, button_menu, 0);
flexpanel_node_insert_child(button_container, button_restart, 1);
flexpanel_node_insert_child(button_container, button_editor, 2);

flexpanel_node_insert_child(win_panel, title_node, 0);
flexpanel_node_insert_child(win_panel, button_container, 1);

flexpanel_node_insert_child(ui_layer_root, win_panel, 0);

// Calculate layout
var display_w = display_get_gui_width();
var display_h = display_get_gui_height();
flexpanel_calculate_layout(ui_layer_root, display_w, display_h, flexpanel_direction.LTR);

// Get calculated positions for drawing
panel_layout = flexpanel_node_layout_get_position(win_panel, false);
title_layout = flexpanel_node_layout_get_position(title_node, false);
button_menu_layout = flexpanel_node_layout_get_position(button_menu, false);
button_restart_layout = flexpanel_node_layout_get_position(button_restart, false);
button_editor_layout = flexpanel_node_layout_get_position(button_editor, false);

// Debug: Check if layouts were retrieved successfully
if (panel_layout == undefined) {
    show_debug_message("ERROR: panel_layout is undefined!");
} else {
    show_debug_message("Panel layout retrieved successfully");
    show_debug_message("Panel left: " + string(panel_layout.left) + ", top: " + string(panel_layout.top));
    show_debug_message("Panel w: " + string(panel_layout.width) + ", h: " + string(panel_layout.height));
}
