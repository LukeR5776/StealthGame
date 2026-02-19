if (!menu_active) {
    exit;
}

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_alpha(0.95);
draw_rectangle_color(0, 0, gui_w, gui_h, color_bg, color_bg, color_bg, color_bg, false);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(color_title);

var title_y = gui_h * 0.25;
draw_text_transformed(gui_w / 2, title_y, "HEIST GAME", 2, 2, 0);

var button_width = 300;
var button_height = 60;
var button_x = (gui_w / 2) - (button_width / 2);
var button_spacing = 80;
var first_button_y = gui_h * 0.5;

button_campaign.left = button_x;
button_campaign.top = first_button_y;
button_campaign.width = button_width;
button_campaign.height = button_height;

button_editor.left = button_x;
button_editor.top = first_button_y + button_spacing;
button_editor.width = button_width;
button_editor.height = button_height;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var hover_campaign = point_in_rectangle(mx, my,
    button_campaign.left, button_campaign.top,
    button_campaign.left + button_campaign.width,
    button_campaign.top + button_campaign.height);

var campaign_color = hover_campaign ? color_button_hover : color_button_normal;

draw_rectangle_color(
    button_campaign.left, button_campaign.top,
    button_campaign.left + button_campaign.width,
    button_campaign.top + button_campaign.height,
    campaign_color, campaign_color, campaign_color, campaign_color, false
);

draw_rectangle_color(
    button_campaign.left, button_campaign.top,
    button_campaign.left + button_campaign.width,
    button_campaign.top + button_campaign.height,
    c_white, c_white, c_white, c_white, true
);

draw_set_color(color_button_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(
    button_campaign.left + button_campaign.width / 2,
    button_campaign.top + button_campaign.height / 2,
    "CAMPAIGN"
);

var hover_editor = point_in_rectangle(mx, my,
    button_editor.left, button_editor.top,
    button_editor.left + button_editor.width,
    button_editor.top + button_editor.height);

var editor_color = hover_editor ? color_button_hover : color_button_normal;

draw_rectangle_color(
    button_editor.left, button_editor.top,
    button_editor.left + button_editor.width,
    button_editor.top + button_editor.height,
    editor_color, editor_color, editor_color, editor_color, false
);

draw_rectangle_color(
    button_editor.left, button_editor.top,
    button_editor.left + button_editor.width,
    button_editor.top + button_editor.height,
    c_white, c_white, c_white, c_white, true
);

draw_set_color(color_button_text);
draw_text(
    button_editor.left + button_editor.width / 2,
    button_editor.top + button_editor.height / 2,
    "LEVEL EDITOR"
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
