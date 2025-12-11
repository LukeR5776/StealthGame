// Get the camera from the first view
cam = view_camera[0];

// Set camera dimensions
cam_width = 640;
cam_height = 360;

// Set the camera size
camera_set_view_size(cam, cam_width, cam_height);

// Smooth follow settings
follow_speed = 0.05; // Lower = smoother/slower, higher = snappier (0.1 recommended)

// Target to follow
target = obj_player;

if instance_exists(target) {
    x = target.x;
	y = target.y;
}