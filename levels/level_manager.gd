extends Node3D

@export var characters: Array[Node3D] = []

var current_character = 0

func _ready():
	for character in characters.size():
		print(character)
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
