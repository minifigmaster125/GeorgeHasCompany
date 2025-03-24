extends Area3D

@export var required_target: Node3D
const goalMat = preload("res://goalMat.tres")

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body == required_target:
		required_target.get_node("CSGMesh3D").material_override = goalMat
		# This is where you would put the code to go to the next level
	else:
		print("You lose!")
		# This is where you would put the code to restart the level


func _on_body_exited(body):
	if body == required_target:
		required_target.get_node("CSGMesh3D").material_override = null
		# This is where you would put the code to go to the next level
	else:
		print("You lose!")
		# This is where you would put the code to restart the level
