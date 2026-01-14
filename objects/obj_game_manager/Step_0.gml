// Handle game pause state
if (game_paused) {
    // Deactivate all instances except UI objects
    instance_deactivate_all(true);

    // Reactivate essential objects
    instance_activate_object(obj_game_manager);
    instance_activate_object(obj_win_screen);
    instance_activate_object(obj_controller); // Keep controller active for UI
} else {
    // Ensure all instances are active when not paused
    instance_activate_all();
}
