extends Node3D

var current_level = 0
var current_level_scene: Level = null
const levels := ["res://levels/level1.tscn", "res://levels/level_2.tscn"]

@onready var viewport = $SubViewportContainer/SubViewport

func _ready() -> void:
	load_level(current_level)


func load_level(level_idx: int):
	# drop current level, load level at levels index
	var level_scene = load(levels[level_idx])
	current_level_scene = level_scene.instantiate()
	viewport.add_child(current_level_scene)
	current_level_scene.level_completed.connect(level_transition)

func level_transition():
	await current_level_scene.wrap_up()
	current_level_scene.queue_free()
	current_level = current_level + 1
	load_level(current_level)
