extends Node3D
class_name Level

@export var characters: Array[Player] = []
var goals: Array[Goal] = []

signal level_completed

var current_character = 0
var goal_count = 0

func _ready():
	characters.assign((get_tree().get_nodes_in_group("characters").map(func(node: Node) -> Player:
		return node as Player
	)) as Array[Player])
	for child in get_children():
		if child is Goal:
			var goal = child as Goal
			goals.append(child)
			goal.target_entered_goal.connect(_on_target_entered_goal)
			goal.target_exited_goal.connect(_on_target_exited_goal)
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
