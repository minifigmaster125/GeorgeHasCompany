extends Node3D
class_name Mechanism

@export var speed = 0.5
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
var activated = false


func _process(delta):
	if activated:
		if path_follow.progress_ratio <= 1.0:
			path_follow.progress_ratio += delta * speed
		else:
			path_follow.progress_ratio = 1.0

	if !activated:
		if path_follow.progress_ratio > 0.0:
			path_follow.progress_ratio -= delta * speed
		else:
			path_follow.progress_ratio = 0.0

func activate():
	activated = true


func deactivate():
	activated = false
