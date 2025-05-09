extends Node3D
class_name Level

var characters: Array[Player] = []
var goals: Array[Goal] = []

signal level_completed

var current_character = 0
var goal_count = 0

func _ready():
	for child in get_children():
		if child is Goal:
			var goal = child as Goal
			goals.append(child)
			goal.target_entered_goal.connect(_on_target_entered_goal)
			goal.target_exited_goal.connect(_on_target_exited_goal)
		if child is Player:
			characters.append(child)
	for character in characters.size():
		if character != current_character:
			characters[character].deactivate()
		else:
			characters[character].activate()

func _process(_delta):
	if Input.is_action_just_released("switch"):
		characters[current_character].deactivate()
		current_character += 1
		if current_character >= characters.size():
			current_character = 0
		characters[current_character].activate()

func _on_target_entered_goal():
	goal_count += 1
	if goal_count >= goals.size():
		level_completed.emit()


func _on_target_exited_goal():
	goal_count -= 1
	if goal_count < goals.size():
		pass

func wrap_up():
	var tween := create_tween()
	tween.set_parallel()
	for character in characters:
		var mesh := character.get_node("CSGMesh3D")
		tween.tween_property(mesh, "scale", Vector3.ZERO, 0.5)
	await tween.finished

func play_level_completed_sound():
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = load("res://sfx/level_completed.ogg")
	audio_player.volume_db = -10
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()