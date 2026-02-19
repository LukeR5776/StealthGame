// deactivate everything except UI when paused
if (game_paused) {
    instance_deactivate_all(true);

    // keep UI alive
    instance_activate_object(obj_game_manager);
    instance_activate_object(obj_win_screen);
    instance_activate_object(obj_controller);
} else {
    instance_activate_all();
}
