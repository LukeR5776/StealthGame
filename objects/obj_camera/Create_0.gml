cam = view_camera[0];

//camera dimensions
cam_width = 640;
cam_height = 360;

// camera size
camera_set_view_size(cam, cam_width, cam_height);

follow_speed = 0.05;

target = obj_player;

// Build mode camera movement speed
build_cam_speed = 5;

// Start camera at center of room
x = room_width / 2;
y = room_height / 2;