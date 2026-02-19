menu_active = false;
menu_mode = "main";

level_files = [];
level_metadata = {};
selected_index = 0;
scroll_offset = 0;
max_visible_levels = 6;

input_cooldown = 0;
input_cooldown_max = 10;

text_input_active = false;
text_input_string = "";
text_input_max_length = 30;

feedback_message = "";
feedback_timer = 0;
feedback_timer_max = 120;

menu_panel = noone;
ui_layer_root = noone;
layout_calculated = false;

button_save = { left: 0, top: 0, width: 0, height: 0 };
button_load = { left: 0, top: 0, width: 0, height: 0 };
button_export = { left: 0, top: 0, width: 0, height: 0 };
button_import = { left: 0, top: 0, width: 0, height: 0 };
button_close = { left: 0, top: 0, width: 0, height: 0 };
button_new_save = { left: 0, top: 0, width: 0, height: 0 };
button_back = { left: 0, top: 0, width: 0, height: 0 };

list_area = { left: 0, top: 0, width: 0, height: 0 };
list_item_height = 50;

color_bg = c_dkgray;
color_border = c_white;
color_button_normal = c_gray;
color_button_hover = c_ltgray;
color_button_active = c_lime;
color_text = c_white;
color_selected = c_yellow;

load_level_metadata();

function scan_level_files() {
    level_files = [];
    var save_dir = game_save_id + "levels/";

    if (!directory_exists(save_dir)) {
        directory_create(save_dir);
        return;
    }

    var filename = file_find_first(save_dir + "*.json", 0);
    while (filename != "") {
        if (filename != "metadata.json") {
            var name_no_ext = string_replace(filename, ".json", "");
            array_push(level_files, name_no_ext);
        }
        filename = file_find_next();
    }
    file_find_close();

    array_sort(level_files, true);
}

function load_level_metadata() {
    var save_dir = game_save_id + "levels/";
    var meta_path = save_dir + "metadata.json";

    if (!file_exists(meta_path)) {
        level_metadata = {};
        save_level_metadata();
        return;
    }

    var file = file_text_open_read(meta_path);
    if (file == -1) {
        level_metadata = {};
        return;
    }

    var json_string = "";
    while (!file_text_eof(file)) {
        json_string += file_text_read_string(file);
        file_text_readln(file);
    }
    file_text_close(file);

    level_metadata = json_parse(json_string);
    if (level_metadata == undefined) {
        level_metadata = {};
    }
}

function save_level_metadata() {
    var save_dir = game_save_id + "levels/";
    if (!directory_exists(save_dir)) {
        directory_create(save_dir);
    }

    var meta_path = save_dir + "metadata.json";
    var json_string = json_stringify(level_metadata, true);

    var file = file_text_open_write(meta_path);
    if (file != -1) {
        file_text_write_string(file, json_string);
        file_text_close(file);
    }
}

function update_level_metadata(filename, display_name) {
    if (!variable_struct_exists(level_metadata, filename)) {
        level_metadata[$ filename] = {};
    }

    level_metadata[$ filename].display_name = display_name;
    level_metadata[$ filename].last_modified = date_datetime_string(date_current_datetime());
    level_metadata[$ filename].filename = filename;

    save_level_metadata();
}

function get_level_display_name(filename) {
    if (variable_struct_exists(level_metadata, filename)) {
        if (variable_struct_exists(level_metadata[$ filename], "display_name")) {
            return level_metadata[$ filename].display_name;
        }
    }
    return filename;
}

scan_level_files();
