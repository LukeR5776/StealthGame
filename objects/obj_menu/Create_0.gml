menu_active = true;

// init globals if missing
if (!variable_global_exists("campaign_mode")) {
    global.campaign_mode = false;
}
if (!variable_global_exists("current_campaign_level")) {
    global.current_campaign_level = 0;
}

menu_panel = noone;
layout_calculated = false;

button_campaign = { left: 0, top: 0, width: 0, height: 0 };
button_editor = { left: 0, top: 0, width: 0, height: 0 };

color_bg = c_black;
color_title = c_white;
color_button_normal = #2c3e50;
color_button_hover = #34495e;
color_button_text = c_white;

