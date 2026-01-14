// Handle button clicks
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    // Check if clicked on "Back to Editor" button
    if (mx >= button_editor_layout.left && mx <= button_editor_layout.left + button_editor_layout.width &&
        my >= button_editor_layout.top && my <= button_editor_layout.top + button_editor_layout.height) {

        // Return to build mode
        if (instance_exists(obj_controller)) {
            obj_controller.game_mode = "build";

            // Destroy player
            if (instance_exists(obj_player)) {
                instance_destroy(obj_player);
            }
        }

        // Unpause game
        if (instance_exists(obj_game_manager)) {
            obj_game_manager.game_paused = false;
        }

        // Cleanup flex panel
        flexpanel_delete_node(win_panel, true);

        // Destroy this win screen
        instance_destroy();
    }

    // Check if clicked on "Return to Menu" button (TODO)
    if (mx >= button_menu_layout.left && mx <= button_menu_layout.left + button_menu_layout.width &&
        my >= button_menu_layout.top && my <= button_menu_layout.top + button_menu_layout.height) {

        show_debug_message("Return to Menu - TODO: Implement menu system");
        // TODO: Implement return to menu functionality
    }

    // Check if clicked on "Restart Level" button (TODO)
    if (mx >= button_restart_layout.left && mx <= button_restart_layout.left + button_restart_layout.width &&
        my >= button_restart_layout.top && my <= button_restart_layout.top + button_restart_layout.height) {

        show_debug_message("Restart Level - TODO: Implement level restart");
        // TODO: Implement level restart functionality
    }
}
