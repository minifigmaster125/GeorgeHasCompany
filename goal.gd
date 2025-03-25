class_name Goal
extends Area3D

@export var required_target: Node3D
const goalMat = preload("res://goalMat.tres")

signal target_entered_goal
signal target_exited_goal

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body == required_target:
		required_target.get_node("CSGMesh3D").material_override = goalMat
		target_entered_goal.emit()


func _on_body_exited(body):
	if body == required_target:
		required_target.get_node("CSGMesh3D").material_override = null
		target_exited_goal.emit()
