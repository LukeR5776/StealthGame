// only draw if active
if (!menu_active) {
    exit;
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

var panel_w = 600;
var panel_h = 500;
var panel_x = (gui_w - panel_w) / 2;
var panel_y = (gui_h - panel_h) / 2;

draw_set_color(color_bg);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_set_color(color_border);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
var title_text = "LEVEL MANAGER";
if (menu_mode == "save") title_text = "SAVE LEVEL";
else if (menu_mode == "load") title_text = "LOAD LEVEL";

draw_text(panel_x + panel_w/2, panel_y + 20, title_text);

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// main menu mode
if (menu_mode == "main") {
    var btn_w = 250;
    var btn_h = 50;
    var btn_spacing = 15;
    var start_y = panel_y + 80;

    button_save.left = panel_x + (panel_w - btn_w) / 2;
    button_save.top = start_y;
    button_save.width = btn_w;
    button_save.height = btn_h;
    var hover_save = point_in_rectangle(mx, my, button_save.left, button_save.top,
        button_save.left + button_save.width, button_save.top + button_save.height);
    draw_set_color(hover_save ? color_button_hover : color_button_normal);
    draw_rectangle(button_save.left, button_save.top,
        button_save.left + button_save.width, button_save.top + button_save.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_save.left, button_save.top,
        button_save.left + button_save.width, button_save.top + button_save.height, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(button_save.left + btn_w/2, button_save.top + btn_h/2, "Save Level");

    button_load.left = button_save.left;
    button_load.top = start_y + btn_h + btn_spacing;
    button_load.width = btn_w;
    button_load.height = btn_h;
    var hover_load = point_in_rectangle(mx, my, button_load.left, button_load.top,
        button_load.left + button_load.width, button_load.top + button_load.height);
    draw_set_color(hover_load ? color_button_hover : color_button_normal);
    draw_rectangle(button_load.left, button_load.top,
        button_load.left + button_load.width, button_load.top + button_load.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_load.left, button_load.top,
        button_load.left + button_load.width, button_load.top + button_load.height, true);
    draw_set_color(c_white);
    draw_text(button_load.left + btn_w/2, button_load.top + btn_h/2, "Load Level");

    button_export.left = button_save.left;
    button_export.top = start_y + (btn_h + btn_spacing) * 2;
    button_export.width = btn_w;
    button_export.height = btn_h;
    var hover_export = point_in_rectangle(mx, my, button_export.left, button_export.top,
        button_export.left + button_export.width, button_export.top + button_export.height);
    draw_set_color(hover_export ? color_button_hover : color_button_normal);
    draw_rectangle(button_export.left, button_export.top,
        button_export.left + button_export.width, button_export.top + button_export.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_export.left, button_export.top,
        button_export.left + button_export.width, button_export.top + button_export.height, true);
    draw_set_color(c_white);
    draw_text(button_export.left + btn_w/2, button_export.top + btn_h/2, "Export to Clipboard");

    button_import.left = button_save.left;
    button_import.top = start_y + (btn_h + btn_spacing) * 3;
    button_import.width = btn_w;
    button_import.height = btn_h;
    var hover_import = point_in_rectangle(mx, my, button_import.left, button_import.top,
        button_import.left + button_import.width, button_import.top + button_import.height);
    draw_set_color(hover_import ? color_button_hover : color_button_normal);
    draw_rectangle(button_import.left, button_import.top,
        button_import.left + button_import.width, button_import.top + button_import.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_import.left, button_import.top,
        button_import.left + button_import.width, button_import.top + button_import.height, true);
    draw_set_color(c_white);
    draw_text(button_import.left + btn_w/2, button_import.top + btn_h/2, "Import from Clipboard");

    button_close.left = button_save.left;
    button_close.top = start_y + (btn_h + btn_spacing) * 4;
    button_close.width = btn_w;
    button_close.height = btn_h;
    var hover_close = point_in_rectangle(mx, my, button_close.left, button_close.top,
        button_close.left + button_close.width, button_close.top + button_close.height);
    draw_set_color(hover_close ? color_button_hover : color_button_normal);
    draw_rectangle(button_close.left, button_close.top,
        button_close.left + button_close.width, button_close.top + button_close.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_close.left, button_close.top,
        button_close.left + button_close.width, button_close.top + button_close.height, true);
    draw_set_color(c_white);
    draw_text(button_close.left + btn_w/2, button_close.top + btn_h/2, "Close");
}

else if (menu_mode == "save") {
    var btn_w = 100;
    var btn_h = 40;
    button_back.left = panel_x + 20;
    button_back.top = panel_y + panel_h - btn_h - 20;
    button_back.width = btn_w;
    button_back.height = btn_h;
    var hover_back = point_in_rectangle(mx, my, button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height);
    draw_set_color(hover_back ? color_button_hover : color_button_normal);
    draw_rectangle(button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(button_back.left + btn_w/2, button_back.top + btn_h/2, "Back");

    button_new_save.left = panel_x + panel_w - btn_w * 2 - 20;
    button_new_save.top = panel_y + panel_h - btn_h - 20;
    button_new_save.width = btn_w * 2;
    button_new_save.height = btn_h;
    var hover_new = point_in_rectangle(mx, my, button_new_save.left, button_new_save.top,
        button_new_save.left + button_new_save.width, button_new_save.top + button_new_save.height);
    draw_set_color(hover_new ? color_button_active : color_button_normal);
    draw_rectangle(button_new_save.left, button_new_save.top,
        button_new_save.left + button_new_save.width, button_new_save.top + button_new_save.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_new_save.left, button_new_save.top,
        button_new_save.left + button_new_save.width, button_new_save.top + button_new_save.height, true);
    draw_set_color(c_white);
    draw_text(button_new_save.left + btn_w, button_new_save.top + btn_h/2, "New Save");

    list_area.left = panel_x + 20;
    list_area.top = panel_y + 60;
    list_area.width = panel_w - 40;
    list_area.height = panel_h - 140;

    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(list_area.left, list_area.top,
        list_area.left + list_area.width, list_area.top + list_area.height, false);
    draw_set_alpha(1);
    draw_set_color(color_border);
    draw_rectangle(list_area.left, list_area.top,
        list_area.left + list_area.width, list_area.top + list_area.height, true);

    if (array_length(level_files) == 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_ltgray);
        draw_text(list_area.left + list_area.width/2, list_area.top + list_area.height/2,
            "No saved levels\nClick 'New Save' to create one");
    } else {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        for (var i = 0; i < array_length(level_files); i++) {
            var draw_y = list_area.top + (i - scroll_offset) * list_item_height;

            if (draw_y < list_area.top || draw_y + list_item_height > list_area.top + list_area.height) {
                continue;
            }

            var filename = level_files[i];
            var display_name = get_level_display_name(filename);

            var list_y = my - list_area.top;
            var hovered_index = floor(list_y / list_item_height) + scroll_offset;
            var is_hovered = (hovered_index == i && point_in_rectangle(mx, my, list_area.left, list_area.top,
                list_area.left + list_area.width, list_area.top + list_area.height));

            if (is_hovered) {
                draw_set_color(c_gray);
                draw_set_alpha(0.5);
                draw_rectangle(list_area.left + 5, draw_y,
                    list_area.left + list_area.width - 5, draw_y + list_item_height - 5, false);
                draw_set_alpha(1);
            }

            draw_set_color(c_white);
            draw_text(list_area.left + 10, draw_y + 5, display_name);

            if (variable_struct_exists(level_metadata, filename)) {
                var meta = level_metadata[$ filename];
                if (variable_struct_exists(meta, "last_modified")) {
                    draw_set_color(c_ltgray);
                    draw_text(list_area.left + 10, draw_y + 25, meta.last_modified);
                }
            }
        }
    }

    if (text_input_active) {
        var input_w = 400;
        var input_h = 100;
        var input_x = (gui_w - input_w) / 2;
        var input_y = (gui_h - input_h) / 2;

        draw_set_color(c_dkgray);
        draw_rectangle(input_x, input_y, input_x + input_w, input_y + input_h, false);
        draw_set_color(c_white);
        draw_rectangle(input_x, input_y, input_x + input_w, input_y + input_h, true);

        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_text(input_x + input_w/2, input_y + 10, "Enter level name:");

        draw_set_color(c_black);
        draw_rectangle(input_x + 20, input_y + 40, input_x + input_w - 20, input_y + 70, false);
        draw_set_color(c_white);
        draw_rectangle(input_x + 20, input_y + 40, input_x + input_w - 20, input_y + 70, true);

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(input_x + 30, input_y + 55, text_input_string + "_");

        draw_set_halign(fa_center);
        draw_set_color(c_ltgray);
        draw_text(input_x + input_w/2, input_y + 80, "Press Enter to save, ESC to cancel");
    }
}

else if (menu_mode == "load") {
    var btn_w = 100;
    var btn_h = 40;
    button_back.left = panel_x + 20;
    button_back.top = panel_y + panel_h - btn_h - 20;
    button_back.width = btn_w;
    button_back.height = btn_h;
    var hover_back = point_in_rectangle(mx, my, button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height);
    draw_set_color(hover_back ? color_button_hover : color_button_normal);
    draw_rectangle(button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height, false);
    draw_set_color(color_border);
    draw_rectangle(button_back.left, button_back.top,
        button_back.left + button_back.width, button_back.top + button_back.height, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(button_back.left + btn_w/2, button_back.top + btn_h/2, "Back");

    list_area.left = panel_x + 20;
    list_area.top = panel_y + 60;
    list_area.width = panel_w - 40;
    list_area.height = panel_h - 140;

    draw_set_color(c_black);
    draw_set_alpha(0.3);
    draw_rectangle(list_area.left, list_area.top,
        list_area.left + list_area.width, list_area.top + list_area.height, false);
    draw_set_alpha(1);
    draw_set_color(color_border);
    draw_rectangle(list_area.left, list_area.top,
        list_area.left + list_area.width, list_area.top + list_area.height, true);

    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(c_ltgray);
    draw_text(panel_x + panel_w - 30, panel_y + panel_h - 30,
        "Click to load | Delete key to remove");

    if (array_length(level_files) == 0) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_ltgray);
        draw_text(list_area.left + list_area.width/2, list_area.top + list_area.height/2,
            "No saved levels found");
    } else {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        for (var i = 0; i < array_length(level_files); i++) {
            var draw_y = list_area.top + (i - scroll_offset) * list_item_height;

            if (draw_y < list_area.top || draw_y + list_item_height > list_area.top + list_area.height) {
                continue;
            }

            var filename = level_files[i];
            var display_name = get_level_display_name(filename);

            var list_y = my - list_area.top;
            var hovered_index = floor(list_y / list_item_height) + scroll_offset;
            var is_hovered = (hovered_index == i && point_in_rectangle(mx, my, list_area.left, list_area.top,
                list_area.left + list_area.width, list_area.top + list_area.height));
            var is_selected = (selected_index == i);

            if (is_selected || is_hovered) {
                draw_set_color(is_selected ? color_selected : c_gray);
                draw_set_alpha(is_selected ? 0.3 : 0.5);
                draw_rectangle(list_area.left + 5, draw_y,
                    list_area.left + list_area.width - 5, draw_y + list_item_height - 5, false);
                draw_set_alpha(1);
            }

            draw_set_color(is_selected ? color_selected : c_white);
            draw_text(list_area.left + 10, draw_y + 5, display_name);

            if (variable_struct_exists(level_metadata, filename)) {
                var meta = level_metadata[$ filename];
                if (variable_struct_exists(meta, "last_modified")) {
                    draw_set_color(c_ltgray);
                    draw_text(list_area.left + 10, draw_y + 25, meta.last_modified);
                }
            }
        }
    }
}

if (feedback_message != "" && feedback_timer > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var fade = min(1, feedback_timer / 30);
    draw_set_alpha(fade);

    var msg_w = string_width(feedback_message) + 40;
    var msg_h = 40;
    var msg_x = gui_w / 2 - msg_w / 2;
    var msg_y = gui_h - 80;

    draw_set_color(c_black);
    draw_rectangle(msg_x, msg_y, msg_x + msg_w, msg_y + msg_h, false);
    draw_set_color(color_button_active);
    draw_rectangle(msg_x, msg_y, msg_x + msg_w, msg_y + msg_h, true);

    draw_set_color(c_white);
    draw_text(gui_w / 2, msg_y + msg_h / 2, feedback_message);

    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
