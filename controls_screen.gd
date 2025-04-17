extends Control

@onready var back_button := $MarginContainer/VBoxContainer/HBoxContainer/BackButton

func _ready():
	back_button.grab_focus()

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
				back_button.emit_signal("pressed")

