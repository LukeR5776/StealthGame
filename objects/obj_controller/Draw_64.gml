// Display current selection and controls
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Show current selection
var selection_text = "";
if (current_selection == PLACE_WALL) {
    selection_text = "Wall";
} else if (current_selection == PLACE_PLAYER_SPAWN) {
    selection_text = "Player Spawn";
} else if (current_selection == PLACE_GOAL) {
    selection_text = "Goal";
} else if (current_selection == PLACE_SECURITY_CAM) {
    selection_text = "Security Cam";
}

draw_text(20, 20, "Selected: " + selection_text);

// Show camera direction if security cam is selected
if (current_selection == PLACE_SECURITY_CAM) {
    draw_text(20, 40, "Camera Direction: " + string(camera_placement_direction) + "°");
}

// Show controls
draw_text(20, 60, "Controls:");
draw_text(20, 80, "Q/E - Cycle Objects");
draw_text(20, 100, "Left Click - Place");
draw_text(20, 120, "Right Click - Remove");
draw_text(20, 140, "Space - Respawn Player");

// Show camera rotation controls only when security cam is selected
if (current_selection == PLACE_SECURITY_CAM) {
    draw_text(20, 160, "R/T - Rotate Camera");
}

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
