// collect objective
if (instance_exists(obj_player)) {
    var dist = point_distance(x, y, obj_player.x, obj_player.y);

    if (dist <= 32) {
        if (keyboard_check_pressed(ord("F"))) {
            if (instance_exists(obj_controller)) {
                obj_controller.goals_collected++;
            }

            // remove from grid
            var tile_x = x div obj_controller.tile_w;
            var tile_y = y div obj_controller.tile_h;
            obj_controller.goal_objects[tile_x][tile_y] = noone;

            instance_destroy();
        }
    }
}
