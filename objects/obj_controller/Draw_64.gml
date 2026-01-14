// Display current mode at top
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var mode_text = game_mode == "build" ? "BUILD MODE" : "PLAY MODE";
var mode_color = game_mode == "build" ? c_yellow : c_lime;
draw_set_color(mode_color);
draw_text(20, 20, mode_text + " (P to toggle)");
draw_set_color(c_white);

// Display play mode UI
if (game_mode == "play") {
    // Check if player is detected by any camera or guard
    var is_detected = false;
    with (obj_security_cam) {
        if (player_detected) {
            is_detected = true;
            break;
        }
    }
    with (obj_guard) {
        if (player_detected) {
            is_detected = true;
            break;
        }
    }

    // Display detection status
    var status_text = is_detected ? "Status: DETECTED!" : "Status: UNSEEN";
    var status_color = is_detected ? c_red : c_lime;
    draw_set_color(status_color);
    draw_text(20, 40, status_text);
    draw_set_color(c_white);

    // Display goal counter
    draw_text(20, 60, string(goals_collected) + "/" + string(total_goals) + " Collected");
}

// Display editor UI only in build mode
if (game_mode == "build") {

// Show error message if mode switch failed
if (mode_switch_error != "") {
    draw_set_color(c_red);
    draw_text(20, 40, mode_switch_error);
    draw_set_color(c_white);
}

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
} else if (current_selection == PLACE_EXTRACTION) {
    selection_text = "Extraction";
}

draw_text(20, 60, "Selected: " + selection_text);

// Show camera direction if security cam is selected
if (current_selection == PLACE_SECURITY_CAM) {
    draw_text(20, 80, "Camera Direction: " + string(camera_placement_direction) + "°");
}

// Show guard direction if guard is selected
if (current_selection == PLACE_GUARD) {
    draw_text(20, 80, "Guard Direction: " + string(guard_placement_direction) + "°");
}

// Show door direction if door is selected
if (current_selection == PLACE_DOOR) {
    draw_text(20, 80, "Door Direction: " + string(door_placement_direction) + "°");
}

// Show selected guard for waypoint assignment
if (selected_guard_id != noone && instance_exists(selected_guard_id)) {
    draw_text(20, 80, "Assigning waypoints to Guard #" + string(selected_guard_number));
} else if (selected_guard_number > 0) {
    draw_text(20, 80, "No Guard #" + string(selected_guard_number) + " found");
}

// Show controls
draw_text(20, 100, "Controls:");
draw_text(20, 120, "Q/E - Cycle Objects");
draw_text(20, 140, "Left Click - Place");
draw_text(20, 160, "Right Click - Remove");
draw_text(20, 180, "Space - Respawn Player");

// Show rotation controls when security cam, guard, or door is selected
if (current_selection == PLACE_SECURITY_CAM || current_selection == PLACE_GUARD || current_selection == PLACE_DOOR) {
    draw_text(20, 200, "R/T - Rotate Direction");
}

// Show waypoint assignment controls
if (instance_number(obj_guard) > 0) {
    draw_text(20, 220, "1-9 - Select Guard for Waypoints");
}

} // End of build mode check

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
