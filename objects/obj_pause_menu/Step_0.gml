// ESC or M to close
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("M"))) {
    if (instance_exists(obj_game_manager)) {
        obj_game_manager.game_paused = false;
    }
    instance_destroy();
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(mx, my,
        button_resume.left, button_resume.top,
        button_resume.left + button_resume.width,
        button_resume.top + button_resume.height)) {

        if (instance_exists(obj_game_manager)) {
            obj_game_manager.game_paused = false;
        }
        instance_destroy();
    }

    if (point_in_rectangle(mx, my,
        button_menu.left, button_menu.top,
        button_menu.left + button_menu.width,
        button_menu.top + button_menu.height)) {

        // abandon campaign run
        if (global.current_campaign_level > 0) {
            global.current_campaign_level = 0;
        }

        if (instance_exists(obj_game_manager)) {
            obj_game_manager.game_paused = false;
        }

        room_goto(Menu);
        instance_destroy();
    }
}
