if (!menu_active) {
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(mx, my,
        button_campaign.left, button_campaign.top,
        button_campaign.left + button_campaign.width,
        button_campaign.top + button_campaign.height)) {

        instance_create_layer(0, 0, "Instances", obj_campaign);
        menu_active = false;
    }

    if (point_in_rectangle(mx, my,
        button_editor.left, button_editor.top,
        button_editor.left + button_editor.width,
        button_editor.top + button_editor.height)) {

        room_goto(Game);
    }
}
