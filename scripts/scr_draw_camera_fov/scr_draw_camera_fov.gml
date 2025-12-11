function scr_draw_camera_fov(cam_x, cam_y, cone_dir, cone_half_angle, cone_range, color, alpha) {
    // Use static arrays to avoid allocation every frame
    static wall_left = [];
    static wall_right = [];
    static wall_top = [];
    static wall_bottom = [];
    static angles = [];
    static sort_keys = [];
    static vert_x = [];
    static vert_y = [];

    var min_angle = cone_dir - cone_half_angle;
    var max_angle = cone_dir + cone_half_angle;
    var corner_offset = 0.057;
    var max_wall_dist = cone_range + 64;

    // === SINGLE PASS: Cache walls AND gather corner angles ===
    var wall_count = 0;
    var angle_count = 0;

    // Add boundary and subdivision angles first
    angles[angle_count++] = min_angle;
    angles[angle_count++] = max_angle;

    var angle_step = 5;
    for (var a = min_angle + angle_step; a < max_angle; a += angle_step) {
        angles[angle_count++] = a;
    }

    // Single iteration through walls - cache bbox AND collect corners
    with (obj_wall) {
        var dist_to_wall = point_distance(cam_x, cam_y, x, y);
        if (dist_to_wall > max_wall_dist) continue;

        // Cache this wall's bounds
        var wl = bbox_left;
        var wr = bbox_right;
        var wt = bbox_top;
        var wb = bbox_bottom;

        wall_left[wall_count] = wl;
        wall_right[wall_count] = wr;
        wall_top[wall_count] = wt;
        wall_bottom[wall_count] = wb;
        wall_count++;

        // Check corners inline (unrolled for speed)
        var cx, cy, cd, ca, ad;

        // Top-left
        cx = wl; cy = wt;
        cd = point_distance(cam_x, cam_y, cx, cy);
        if (cd <= cone_range) {
            ca = point_direction(cam_x, cam_y, cx, cy);
            ad = angle_difference(cone_dir, ca);
            if (abs(ad) <= cone_half_angle + 5) {
                angles[angle_count++] = ca;
                angles[angle_count++] = ca - corner_offset;
                angles[angle_count++] = ca + corner_offset;
            }
        }

        // Top-right
        cx = wr; cy = wt;
        cd = point_distance(cam_x, cam_y, cx, cy);
        if (cd <= cone_range) {
            ca = point_direction(cam_x, cam_y, cx, cy);
            ad = angle_difference(cone_dir, ca);
            if (abs(ad) <= cone_half_angle + 5) {
                angles[angle_count++] = ca;
                angles[angle_count++] = ca - corner_offset;
                angles[angle_count++] = ca + corner_offset;
            }
        }

        // Bottom-left
        cx = wl; cy = wb;
        cd = point_distance(cam_x, cam_y, cx, cy);
        if (cd <= cone_range) {
            ca = point_direction(cam_x, cam_y, cx, cy);
            ad = angle_difference(cone_dir, ca);
            if (abs(ad) <= cone_half_angle + 5) {
                angles[angle_count++] = ca;
                angles[angle_count++] = ca - corner_offset;
                angles[angle_count++] = ca + corner_offset;
            }
        }

        // Bottom-right
        cx = wr; cy = wb;
        cd = point_distance(cam_x, cam_y, cx, cy);
        if (cd <= cone_range) {
            ca = point_direction(cam_x, cam_y, cx, cy);
            ad = angle_difference(cone_dir, ca);
            if (abs(ad) <= cone_half_angle + 5) {
                angles[angle_count++] = ca;
                angles[angle_count++] = ca - corner_offset;
                angles[angle_count++] = ca + corner_offset;
            }
        }
    }

    // === FAST SORT: Insertion sort with precomputed keys ===
    // Precompute sort keys (angle_difference is expensive)
    for (var i = 0; i < angle_count; i++) {
        sort_keys[i] = angle_difference(cone_dir, angles[i]);
    }

    // Insertion sort - faster than bubble for small arrays, often faster than quicksort too
    for (var i = 1; i < angle_count; i++) {
        var key_sort = sort_keys[i];
        var key_angle = angles[i];
        var j = i - 1;

        while (j >= 0 && sort_keys[j] > key_sort) {
            sort_keys[j + 1] = sort_keys[j];
            angles[j + 1] = angles[j];
            j--;
        }
        sort_keys[j + 1] = key_sort;
        angles[j + 1] = key_angle;
    }

    // === RAYCAST using cached wall data ===
    var vertex_count = 0;

    for (var i = 0; i < angle_count; i++) {
        // Use precomputed sort key for bounds check
        if (abs(sort_keys[i]) > cone_half_angle) continue;

        var angle = angles[i];
        var ray_dx = lengthdir_x(cone_range, angle);
        var ray_dy = lengthdir_y(cone_range, angle);

        // Track closest hit using parametric t (avoids sqrt in distance calc)
        var closest_t = 1.0;
        var hit_x = cam_x + ray_dx;
        var hit_y = cam_y + ray_dy;

        // Check against cached walls
        for (var w = 0; w < wall_count; w++) {
            var wl = wall_left[w];
            var wr = wall_right[w];
            var wt = wall_top[w];
            var wb = wall_bottom[w];

            var t, test_coord;

            // Left edge
            if (ray_dx != 0) {
                t = (wl - cam_x) / ray_dx;
                if (t > 0 && t < closest_t) {
                    test_coord = cam_y + ray_dy * t;
                    if (test_coord >= wt && test_coord <= wb) {
                        closest_t = t;
                        hit_x = wl;
                        hit_y = test_coord;
                    }
                }
            }

            // Right edge
            if (ray_dx != 0) {
                t = (wr - cam_x) / ray_dx;
                if (t > 0 && t < closest_t) {
                    test_coord = cam_y + ray_dy * t;
                    if (test_coord >= wt && test_coord <= wb) {
                        closest_t = t;
                        hit_x = wr;
                        hit_y = test_coord;
                    }
                }
            }

            // Top edge
            if (ray_dy != 0) {
                t = (wt - cam_y) / ray_dy;
                if (t > 0 && t < closest_t) {
                    test_coord = cam_x + ray_dx * t;
                    if (test_coord >= wl && test_coord <= wr) {
                        closest_t = t;
                        hit_x = test_coord;
                        hit_y = wt;
                    }
                }
            }

            // Bottom edge
            if (ray_dy != 0) {
                t = (wb - cam_y) / ray_dy;
                if (t > 0 && t < closest_t) {
                    test_coord = cam_x + ray_dx * t;
                    if (test_coord >= wl && test_coord <= wr) {
                        closest_t = t;
                        hit_x = test_coord;
                        hit_y = wb;
                    }
                }
            }
        }

        vert_x[vertex_count] = hit_x;
        vert_y[vertex_count] = hit_y;
        vertex_count++;
    }

    // === DRAW ===
    if (vertex_count > 0) {
        draw_set_color(color);
        draw_set_alpha(alpha);
        draw_primitive_begin(pr_trianglefan);

        draw_vertex(cam_x, cam_y);
        for (var i = 0; i < vertex_count; i++) {
            draw_vertex(vert_x[i], vert_y[i]);
        }

        draw_primitive_end();
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}