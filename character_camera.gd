extends Camera3D

@export var sensitivity := 0.005
@export var return_speed := 3.0
@export var max_pitch := 45.0
@export var min_pitch := -30.0
@export var neutral_pitch := 10.0
@export var neutral_yaw := 0.0

var yaw := 0.0
var pitch := deg_to_rad(neutral_pitch)
var rotating := false

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		rotating = event.pressed
	elif event is InputEventMouseMotion and rotating:
		yaw -= event.relative.x * sensitivity
		pitch = clamp(pitch - event.relative.y * sensitivity, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

func _process(delta):
	if not rotating:
		yaw = lerp(yaw, deg_to_rad(neutral_yaw), delta * return_speed)
		pitch = lerp(pitch, deg_to_rad(neutral_pitch), delta * return_speed)

	# Apply offset rotation on top of the player's transform
	var local_rot = Basis()
	local_rot = local_rot.rotated(Vector3.UP, yaw)
	local_rot = local_rot.rotated(Vector3.RIGHT, pitch)
	
	# Set the camera's local basis (relative to player)
	transform.basis = local_rot
