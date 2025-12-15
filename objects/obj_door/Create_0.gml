// Door properties
door_direction = 0; // 0=up, 90=right, 180=down, 270=left (will be set by placement code)
is_open = false; // Track open/closed state

// Default sprite (will be updated in Step based on door_direction)
sprite_index = spr_door_forward;
image_xscale = 1;
image_index = 0; // Closed

// Start as solid (closed door blocks movement)
solid = true;

// Y-sorting depth
depth = 0;
