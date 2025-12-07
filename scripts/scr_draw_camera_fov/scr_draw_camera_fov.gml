function scr_draw_camera_fov(cam_x, cam_y, cone_dir, cone_half_angle, cone_range, color, alpha) {
    // Angle bounds for cone
    var min_angle = cone_dir - cone_half_angle;
    var max_angle = cone_dir + cone_half_angle;

    //store all angles to cast rays at
    var angles = [];
    var angle_count = 0;

    // Small offset for corner sampling
    var corner_offset = 0.057;

    // Add cone boundary angles
    angles[angle_count++] = min_angle;
    angles[angle_count++] = max_angle;

    // Find all wall corners within the cone range
    with (obj_wall) {
        var dist_to_wall = point_distance(cam_x, cam_y, x, y);

        // Only consider walls within range + margin
        if (dist_to_wall <= cone_range + 64) {
            // Check all 4 corners of the wall
            var corners = [
                [bbox_left, bbox_top],
                [bbox_right, bbox_top],
                [bbox_left, bbox_bottom],
                [bbox_right, bbox_bottom]
            ];

            for (var i = 0; i < 4; i++) {
                var corner_x = corners[i][0];
                var corner_y = corners[i][1];
                var corner_dist = point_distance(cam_x, cam_y, corner_x, corner_y);

                // Only process corners within range
                if (corner_dist <= cone_range) {
                    var corner_angle = point_direction(cam_x, cam_y, corner_x, corner_y);

                    // Calculate angle difference accounting for wraparound
                    var angle_diff = angle_difference(cone_dir, corner_angle);

                    // Only add if corner is within cone bounds (with small margin)
                    if (abs(angle_diff) <= cone_half_angle + 5) {
                        // Add the corner angle and small offsets
                        angles[angle_count++] = corner_angle;
                        angles[angle_count++] = corner_angle - corner_offset;
                        angles[angle_count++] = corner_angle + corner_offset;
                    }
                }
            }
        }
    }

    // Sort angles from min to max
    // Simple bubble sort (adequate for typical angle counts < 100)
    for (var i = 0; i < angle_count - 1; i++) {
        for (var j = 0; j < angle_count - i - 1; j++) {
            // Normalize angles relative to cone center for proper sorting
            var norm_j = angle_difference(cone_dir, angles[j]);
            var norm_j1 = angle_difference(cone_dir, angles[j + 1]);

            if (norm_j > norm_j1) {
                var temp = angles[j];
                angles[j] = angles[j + 1];
                angles[j + 1] = temp;
            }
        }
    }

    // Array to store final polygon vertices
    var vertices = [];
    var vertex_count = 0;

    // Cast rays for each angle and store hit points
    for (var i = 0; i < angle_count; i++) {
        var angle = angles[i];

        // Skip angles outside cone bounds (after normalization)
        var angle_diff = angle_difference(cone_dir, angle);
        if (abs(angle_diff) > cone_half_angle) {
            continue;
        }

        // Calculate ray endpoint
        var ray_end_x = cam_x + lengthdir_x(cone_range, angle);
        var ray_end_y = cam_y + lengthdir_y(cone_range, angle);

        // Check for wall collision
        var wall_hit = collision_line(cam_x, cam_y, ray_end_x, ray_end_y, obj_wall, false, true);

        if (wall_hit != noone) {
            // Calculate precise intersection point with wall bbox
            var ray_dx = ray_end_x - cam_x;
            var ray_dy = ray_end_y - cam_y;

            var closest_dist = cone_range;
            var closest_x = ray_end_x;
            var closest_y = ray_end_y;

            // Check intersection with all four edges using parametric form
            // Left edge (x = bbox_left)
            if (ray_dx != 0) {
                var t = (wall_hit.bbox_left - cam_x) / ray_dx;
                if (t > 0 && t <= 1) {
                    var test_y = cam_y + ray_dy * t;
                    if (test_y >= wall_hit.bbox_top && test_y <= wall_hit.bbox_bottom) {
                        var dist = point_distance(cam_x, cam_y, wall_hit.bbox_left, test_y);
                        if (dist < closest_dist) {
                            closest_dist = dist;
                            closest_x = wall_hit.bbox_left;
                            closest_y = test_y;
                        }
                    }
                }
            }

            // Right edge (x = bbox_right)
            if (ray_dx != 0) {
                var t = (wall_hit.bbox_right - cam_x) / ray_dx;
                if (t > 0 && t <= 1) {
                    var test_y = cam_y + ray_dy * t;
                    if (test_y >= wall_hit.bbox_top && test_y <= wall_hit.bbox_bottom) {
                        var dist = point_distance(cam_x, cam_y, wall_hit.bbox_right, test_y);
                        if (dist < closest_dist) {
                            closest_dist = dist;
                            closest_x = wall_hit.bbox_right;
                            closest_y = test_y;
                        }
                    }
                }
            }

            // Top edge (y = bbox_top)
            if (ray_dy != 0) {
                var t = (wall_hit.bbox_top - cam_y) / ray_dy;
                if (t > 0 && t <= 1) {
                    var test_x = cam_x + ray_dx * t;
                    if (test_x >= wall_hit.bbox_left && test_x <= wall_hit.bbox_right) {
                        var dist = point_distance(cam_x, cam_y, test_x, wall_hit.bbox_top);
                        if (dist < closest_dist) {
                            closest_dist = dist;
                            closest_x = test_x;
                            closest_y = wall_hit.bbox_top;
                        }
                    }
                }
            }

            // Bottom edge (y = bbox_bottom)
            if (ray_dy != 0) {
                var t = (wall_hit.bbox_bottom - cam_y) / ray_dy;
                if (t > 0 && t <= 1) {
                    var test_x = cam_x + ray_dx * t;
                    if (test_x >= wall_hit.bbox_left && test_x <= wall_hit.bbox_right) {
                        var dist = point_distance(cam_x, cam_y, test_x, wall_hit.bbox_bottom);
                        if (dist < closest_dist) {
                            closest_dist = dist;
                            closest_x = test_x;
                            closest_y = wall_hit.bbox_bottom;
                        }
                    }
                }
            }

            vertices[vertex_count++] = [closest_x, closest_y];
        } else {
            // No wall hit - use full range
            vertices[vertex_count++] = [ray_end_x, ray_end_y];
        }
    }

    // Draw the visibility polygon as a single triangle fan
    if (vertex_count > 0) {
        draw_set_color(color);
        draw_set_alpha(alpha);

        draw_primitive_begin(pr_trianglefan);

        // Center vertex at camera position
        draw_vertex(cam_x, cam_y);

        // Add all computed vertices in order
        for (var i = 0; i < vertex_count; i++) {
            draw_vertex(vertices[i][0], vertices[i][1]);
        }

        draw_primitive_end();

        // Reset draw settings
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}