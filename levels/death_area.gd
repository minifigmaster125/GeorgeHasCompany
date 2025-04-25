extends Area3D


@export var spawn_point_one := Node3D
@export var spawn_point_two := Node3D

func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D):
	var character = body as Player
	body.position = character.spawn_location.position
