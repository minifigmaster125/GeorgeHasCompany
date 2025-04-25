extends Node3D
class_name Mechanism

@export var speed = 0.5
@onready var path_follow: PathFollow3D = $Path3D/PathFollow3D
var activated = false
var finished = true
@export var lift_sound: AudioStream
var player: AudioStreamPlayer3D = AudioStreamPlayer3D.new()

func _ready():
	player.stream = lift_sound
	player.volume_db = 0.0
	add_child(player)


func _process(delta):
	if activated:
		if path_follow.progress_ratio < 1.0:
			path_follow.progress_ratio += delta * speed
		else:
			finished = true
			path_follow.progress_ratio = 1.0

	if !activated:
		if path_follow.progress_ratio > 0.0:
			path_follow.progress_ratio -= delta * speed
		else:
			finished = true
			path_follow.progress_ratio = 0.0

	if finished:
		player.stop()

func activate():
	if !activated:
		activated = true
		finished = false
		player.play()


func deactivate():
	if activated:
		activated = false
		finished = false
		player.play()
