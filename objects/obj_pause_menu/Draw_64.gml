var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

draw_set_alpha(0.7);
draw_rectangle_color(0, 0, gui_w, gui_h, color_bg_dark, color_bg_dark, color_bg_dark, color_bg_dark, false);
draw_set_alpha(1);

var panel_w = 400;
var panel_h = 300;
var panel_x = (gui_w - panel_w) / 2;
var panel_y = (gui_h - panel_h) / 2;

draw_rectangle_color(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h,
    color_panel_bg, color_panel_bg, color_panel_bg, color_panel_bg, false);

draw_rectangle_color(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h,
    color_border, color_border, color_border, color_border, true);

draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(color_title);
draw_text(panel_x + panel_w / 2, panel_y + 30, "PAUSED");

var button_width = 250;
var button_height = 50;
var button_x = panel_x + (panel_w - button_width) / 2;
var first_button_y = panel_y + 100;
var button_spacing = 70;

button_resume.left = button_x;
button_resume.top = first_button_y;
button_resume.width = button_width;
button_resume.height = button_height;

button_menu.left = button_x;
button_menu.top = first_button_y + button_spacing;
button_menu.width = button_width;
button_menu.height = button_height;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var hover_resume = point_in_rectangle(mx, my,
    button_resume.left, button_resume.top,
    button_resume.left + button_resume.width,
    button_resume.top + button_resume.height);

var resume_color = hover_resume ? color_button_hover : color_button_normal;

draw_rectangle_color(
    button_resume.left, button_resume.top,
    button_resume.left + button_resume.width,
    button_resume.top + button_resume.height,
    resume_color, resume_color, resume_color, resume_color, false
);

draw_rectangle_color(
    button_resume.left, button_resume.top,
    button_resume.left + button_resume.width,
    button_resume.top + button_resume.height,
    color_border, color_border, color_border, color_border, true
);

draw_set_color(color_button_text);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(
    button_resume.left + button_resume.width / 2,
    button_resume.top + button_resume.height / 2,
    "RESUME"
);

var hover_menu = point_in_rectangle(mx, my,
    button_menu.left, button_menu.top,
    button_menu.left + button_menu.width,
    button_menu.top + button_menu.height);

var menu_color = hover_menu ? color_button_hover : color_button_normal;

draw_rectangle_color(
    button_menu.left, button_menu.top,
    button_menu.left + button_menu.width,
    button_menu.top + button_menu.height,
    menu_color, menu_color, menu_color, menu_color, false
);

draw_rectangle_color(
    button_menu.left, button_menu.top,
    button_menu.left + button_menu.width,
    button_menu.top + button_menu.height,
    color_border, color_border, color_border, color_border, true
);

draw_set_color(color_button_text);
draw_text(
    button_menu.left + button_menu.width / 2,
    button_menu.top + button_menu.height / 2,
    "BACK TO MENU"
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
