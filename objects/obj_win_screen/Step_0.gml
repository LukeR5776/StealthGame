if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // back to editor
    if (mx >= button_editor_layout.left && mx <= button_editor_layout.left + button_editor_layout.width &&
        my >= button_editor_layout.top && my <= button_editor_layout.top + button_editor_layout.height) {

        if (instance_exists(obj_controller)) {
            obj_controller.game_mode = "build";

            scr_restore_level_snapshot(obj_controller.level_snapshot);
        }

        if (instance_exists(obj_game_manager)) {
            obj_game_manager.game_paused = false;
        }

        flexpanel_delete_node(win_panel, true);

        instance_destroy();
    }

    // return to menu
    if (mx >= button_menu_layout.left && mx <= button_menu_layout.left + button_menu_layout.width &&
        my >= button_menu_layout.top && my <= button_menu_layout.top + button_menu_layout.height) {

        // save campaign progress
        if (global.current_campaign_level > 0) {
            set_level_completed(global.current_campaign_level);
            save_campaign_progress();
            global.current_campaign_level = 0;
            show_debug_message("Campaign level completed and progress saved");
        }

        if (instance_exists(obj_game_manager)) {
            obj_game_manager.game_paused = false;
        }

        flexpanel_delete_node(win_panel, true);

        room_goto(Menu);
        instance_destroy();
    }

    // restart (TODO)
    if (mx >= button_restart_layout.left && mx <= button_restart_layout.left + button_restart_layout.width &&
        my >= button_restart_layout.top && my <= button_restart_layout.top + button_restart_layout.height) {

        show_debug_message("Restart Level - TODO: Implement level restart");
    }
}
