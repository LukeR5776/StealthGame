// only process if active
if (!menu_active) {
    exit;
}

if (input_cooldown > 0) {
    input_cooldown--;
}

if (feedback_timer > 0) {
    feedback_timer--;
    if (feedback_timer == 0) {
        feedback_message = "";
    }
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// text input mode
if (text_input_active) {
    var key_string = keyboard_string;
    text_input_string = string_copy(key_string, 1, text_input_max_length);

    if (keyboard_check_pressed(vk_enter)) {
        if (text_input_string != "") {
            var filename = string_replace_all(text_input_string, " ", "_");
            filename = string_lower(filename);
            filename = "level_" + filename;

            if (scr_save_level(filename)) {
                update_level_metadata(filename, text_input_string);
                scan_level_files();
                feedback_message = "Level saved: " + text_input_string;
                feedback_timer = feedback_timer_max;
                menu_mode = "main";
            } else {
                feedback_message = "Failed to save level!";
                feedback_timer = feedback_timer_max;
            }

            text_input_active = false;
            text_input_string = "";
            keyboard_string = "";
        }
    }

    if (keyboard_check_pressed(vk_escape)) {
        text_input_active = false;
        text_input_string = "";
        keyboard_string = "";
        menu_mode = "main";
    }

    exit;
}

// esc to close or go back
if (keyboard_check_pressed(vk_escape) && input_cooldown == 0) {
    if (menu_mode == "main") {
        menu_active = false;
    } else {
        menu_mode = "main";
        selected_index = 0;
    }
    input_cooldown = input_cooldown_max;
    exit;
}

// main menu mode
if (menu_mode == "main") {
    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mx, my, button_save.left, button_save.top,
            button_save.left + button_save.width, button_save.top + button_save.height)) {
            menu_mode = "save";
            selected_index = 0;
            scan_level_files();
        }

        if (point_in_rectangle(mx, my, button_load.left, button_load.top,
            button_load.left + button_load.width, button_load.top + button_load.height)) {
            menu_mode = "load";
            selected_index = 0;
            scan_level_files();
        }

        if (point_in_rectangle(mx, my, button_export.left, button_export.top,
            button_export.left + button_export.width, button_export.top + button_export.height)) {
            var code = scr_export_level_code();
            if (code != undefined) {
                feedback_message = "Level code copied to clipboard!";
                feedback_timer = feedback_timer_max;
            } else {
                feedback_message = "Failed to export level code!";
                feedback_timer = feedback_timer_max;
            }
        }

        if (point_in_rectangle(mx, my, button_import.left, button_import.top,
            button_import.left + button_import.width, button_import.top + button_import.height)) {
            if (scr_import_level_code()) {
                feedback_message = "Level imported from clipboard!";
                feedback_timer = feedback_timer_max;
                menu_active = false;
            } else {
                feedback_message = "Failed to import level code!";
                feedback_timer = feedback_timer_max;
            }
        }

        if (point_in_rectangle(mx, my, button_close.left, button_close.top,
            button_close.left + button_close.width, button_close.top + button_close.height)) {
            menu_active = false;
        }
    }
}

// save menu mode
else if (menu_mode == "save") {
    if (keyboard_check_pressed(vk_up) && input_cooldown == 0) {
        selected_index = max(0, selected_index - 1);
        input_cooldown = input_cooldown_max / 2;
    }
    if (keyboard_check_pressed(vk_down) && input_cooldown == 0) {
        selected_index = min(array_length(level_files), selected_index + 1);
        input_cooldown = input_cooldown_max / 2;
    }

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mx, my, button_back.left, button_back.top,
            button_back.left + button_back.width, button_back.top + button_back.height)) {
            menu_mode = "main";
            selected_index = 0;
        }

        if (point_in_rectangle(mx, my, button_new_save.left, button_new_save.top,
            button_new_save.left + button_new_save.width, button_new_save.top + button_new_save.height)) {
            text_input_active = true;
            text_input_string = "";
            keyboard_string = "";
        }

        if (point_in_rectangle(mx, my, list_area.left, list_area.top,
            list_area.left + list_area.width, list_area.top + list_area.height)) {

            var list_y = my - list_area.top;
            var clicked_index = floor(list_y / list_item_height) + scroll_offset;

            if (clicked_index >= 0 && clicked_index < array_length(level_files)) {
                var filename = level_files[clicked_index];
                if (scr_save_level(filename)) {
                    var display_name = get_level_display_name(filename);
                    update_level_metadata(filename, display_name);
                    feedback_message = "Level overwritten: " + display_name;
                    feedback_timer = feedback_timer_max;
                    menu_mode = "main";
                } else {
                    feedback_message = "Failed to save level!";
                    feedback_timer = feedback_timer_max;
                }
            }
        }
    }
}

// load menu mode
else if (menu_mode == "load") {
    if (keyboard_check_pressed(vk_up) && input_cooldown == 0) {
        selected_index = max(0, selected_index - 1);
        input_cooldown = input_cooldown_max / 2;
    }
    if (keyboard_check_pressed(vk_down) && input_cooldown == 0) {
        selected_index = min(array_length(level_files) - 1, selected_index + 1);
        input_cooldown = input_cooldown_max / 2;
    }

    if (keyboard_check_pressed(vk_enter) && input_cooldown == 0) {
        if (selected_index >= 0 && selected_index < array_length(level_files)) {
            var filename = level_files[selected_index];
            if (scr_load_level(filename)) {
                var display_name = get_level_display_name(filename);
                feedback_message = "Level loaded: " + display_name;
                feedback_timer = feedback_timer_max;
                menu_active = false;
            } else {
                feedback_message = "Failed to load level!";
                feedback_timer = feedback_timer_max;
            }
        }
        input_cooldown = input_cooldown_max;
    }

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(mx, my, button_back.left, button_back.top,
            button_back.left + button_back.width, button_back.top + button_back.height)) {
            menu_mode = "main";
            selected_index = 0;
        }

        if (point_in_rectangle(mx, my, list_area.left, list_area.top,
            list_area.left + list_area.width, list_area.top + list_area.height)) {

            var list_y = my - list_area.top;
            var clicked_index = floor(list_y / list_item_height) + scroll_offset;

            if (clicked_index >= 0 && clicked_index < array_length(level_files)) {
                var filename = level_files[clicked_index];
                if (scr_load_level(filename)) {
                    var display_name = get_level_display_name(filename);
                    feedback_message = "Level loaded: " + display_name;
                    feedback_timer = feedback_timer_max;
                    menu_active = false;
                } else {
                    feedback_message = "Failed to load level!";
                    feedback_timer = feedback_timer_max;
                }
            }
        }
    }

    if (keyboard_check_pressed(vk_delete) && input_cooldown == 0) {
        if (selected_index >= 0 && selected_index < array_length(level_files)) {
            var filename = level_files[selected_index];
            var save_dir = game_save_id + "levels/";
            var filepath = save_dir + filename + ".json";

            if (file_exists(filepath)) {
                file_delete(filepath);
                if (variable_struct_exists(level_metadata, filename)) {
                    variable_struct_remove(level_metadata, filename);
                    save_level_metadata();
                }
                scan_level_files();
                selected_index = min(selected_index, array_length(level_files) - 1);
                feedback_message = "Level deleted";
                feedback_timer = feedback_timer_max;
            }
        }
        input_cooldown = input_cooldown_max;
    }
}
