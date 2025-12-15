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
} else if (current_selection == PLACE_GUARD) {
    selection_text = "Guard";
} else if (current_selection == PLACE_WAYPOINT) {
    selection_text = "Waypoint";
} else if (current_selection == PLACE_DOOR) {
    selection_text = "Door";
}

draw_text(20, 20, "Selected: " + selection_text);

// Show camera direction if security cam is selected
if (current_selection == PLACE_SECURITY_CAM) {
    draw_text(20, 40, "Camera Direction: " + string(camera_placement_direction) + "°");
}

// Show guard direction if guard is selected
if (current_selection == PLACE_GUARD) {
    draw_text(20, 40, "Guard Direction: " + string(guard_placement_direction) + "°");
}

// Show door direction if door is selected
if (current_selection == PLACE_DOOR) {
    draw_text(20, 40, "Door Direction: " + string(door_placement_direction) + "°");
}

// Show selected guard for waypoint assignment
if (selected_guard_id != noone && instance_exists(selected_guard_id)) {
    draw_text(20, 40, "Assigning waypoints to Guard #" + string(selected_guard_number));
} else if (selected_guard_number > 0) {
    draw_text(20, 40, "No Guard #" + string(selected_guard_number) + " found");
}

// Show controls
draw_text(20, 60, "Controls:");
draw_text(20, 80, "Q/E - Cycle Objects");
draw_text(20, 100, "Left Click - Place");
draw_text(20, 120, "Right Click - Remove");
draw_text(20, 140, "Space - Respawn Player");

// Show rotation controls when security cam, guard, or door is selected
if (current_selection == PLACE_SECURITY_CAM || current_selection == PLACE_GUARD || current_selection == PLACE_DOOR) {
    draw_text(20, 160, "R/T - Rotate Direction");
}

// Show waypoint assignment controls
if (instance_number(obj_guard) > 0) {
    draw_text(20, 180, "1-9 - Select Guard for Waypoints");
}

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
