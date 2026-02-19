if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    for (var i = 0; i < array_length(level_slots); i++) {
        var slot = level_slots[i];

        if (point_in_rectangle(mx, my, slot.left, slot.top,
            slot.left + slot.width, slot.top + slot.height)) {

            var level_num = i + 1;
            if (is_level_unlocked(level_num)) {
                selected_level = level_num;
                show_debug_message("Selected level " + string(selected_level));
            }
        }
    }

    if (point_in_rectangle(mx, my, play_button.left, play_button.top,
        play_button.left + play_button.width,
        play_button.top + play_button.height)) {

        if (is_level_unlocked(selected_level)) {
            var level = get_campaign_level_by_num(selected_level);

            if (level != undefined) {
                show_debug_message("Starting campaign level " + string(selected_level) + ": " + level.filename);

                global.campaign_mode = true;
                global.current_campaign_level = selected_level;

                room_goto(Game);
            } else {
                show_debug_message("ERROR: Campaign level data not found for level " + string(selected_level));
            }
        }
    }

    if (point_in_rectangle(mx, my, back_button.left, back_button.top,
        back_button.left + back_button.width,
        back_button.top + back_button.height)) {

        if (instance_exists(obj_menu)) {
            obj_menu.menu_active = true;
        }
        instance_destroy();
    }
}

// ESC to close
if (keyboard_check_pressed(vk_escape)) {
    if (instance_exists(obj_menu)) {
        obj_menu.menu_active = true;
    }
    instance_destroy();
}
