if player_detected == true {
	if (instance_exists(obj_player_spawn)) {
        if (instance_exists(obj_player)) {
            obj_player.x = obj_player_spawn.x;
            obj_player.y = obj_player_spawn.y;
        } else {
            instance_destroy(obj_player);
        }
	}
}