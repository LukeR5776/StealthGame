/// @function get_campaign_progress()
function get_campaign_progress() {
    if (!variable_global_exists("campaign_progress_cache")) {
        global.campaign_progress_cache = load_campaign_progress();
    }
    return global.campaign_progress_cache;
}

/// @function load_campaign_progress()
function load_campaign_progress() {
    var save_dir = game_save_id + "campaign/";
    var filepath = save_dir + "progress.json";

    if (file_exists(filepath)) {
        var buffer = buffer_load(filepath);
        var json_string = buffer_read(buffer, buffer_text);
        buffer_delete(buffer);

        try {
            var progress = json_parse(json_string);

                if (!variable_struct_exists(progress, "completed_levels")) {
                progress.completed_levels = [];
            }
            if (!variable_struct_exists(progress, "current_level")) {
                progress.current_level = 1;
            }

            return progress;
        } catch (e) {
            show_debug_message("ERROR: Failed to parse campaign progress - " + string(e));
            return create_default_progress();
        }
    } else {
        return create_default_progress();
    }
}

/// @function create_default_progress()
function create_default_progress() {
    return {
        completed_levels: [],
        current_level: 1
    };
}

/// @function save_campaign_progress()
function save_campaign_progress() {
    var progress = get_campaign_progress();
    var save_dir = game_save_id + "campaign/";

    if (!directory_exists(save_dir)) {
        directory_create(save_dir);
    }

    var filepath = save_dir + "progress.json";
    var json_string = json_stringify(progress);

    var buffer = buffer_create(string_byte_length(json_string) + 1, buffer_fixed, 1);
    buffer_write(buffer, buffer_text, json_string);
    buffer_save(buffer, filepath);
    buffer_delete(buffer);

    show_debug_message("Campaign progress saved: " + string(array_length(progress.completed_levels)) + " levels completed");
    return true;
}

/// @function set_level_completed(level_num)
function set_level_completed(level_num) {
    var progress = get_campaign_progress();

    if (!array_contains(progress.completed_levels, level_num)) {
        array_push(progress.completed_levels, level_num);

        if (level_num >= progress.current_level) {
            progress.current_level = level_num + 1;
        }

        show_debug_message("Level " + string(level_num) + " completed! Level " + string(progress.current_level) + " unlocked.");
        return true;
    }

    return false;
}

/// @function is_level_unlocked(level_num)
function is_level_unlocked(level_num) {
    var progress = get_campaign_progress();

    if (level_num == 1) {
        return true;
    }

    return array_contains(progress.completed_levels, level_num - 1);
}

/// @function reset_campaign_progress()
function reset_campaign_progress() {
    global.campaign_progress_cache = create_default_progress();
    save_campaign_progress();
    show_debug_message("Campaign progress reset to default");
}
