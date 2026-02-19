// fade out when KO'd
if (is_unconscious) {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, 0.5);
} else {
    draw_self();
}

// vision cone
if (!is_unconscious) {
    var vision_color = c_lime;
    var vision_alpha = 0.2;

    if (player_detected) {
        vision_color = c_red;
        vision_alpha = 0.3;
    } else if (state == "INVESTIGATE") {
        vision_color = c_yellow;
        vision_alpha = 0.25;
    } else if (state == "CHASE") {
        vision_color = c_red;
        vision_alpha = 0.35;
    }

    scr_draw_camera_fov(x, y, facing_direction, cone_angle, cone_length, vision_color, vision_alpha);
}
