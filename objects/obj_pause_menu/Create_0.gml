button_resume = { left: 0, top: 0, width: 0, height: 0 };
button_menu = { left: 0, top: 0, width: 0, height: 0 };

color_bg_dark = c_black;
color_panel_bg = c_dkgray;
color_border = c_white;
color_button_normal = #2c3e50;
color_button_hover = #34495e;
color_button_text = c_white;
color_title = c_white;

if (instance_exists(obj_game_manager)) {
    obj_game_manager.game_paused = true;
}

show_debug_message("Pause menu opened");
