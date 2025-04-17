extends Control

@onready var bgm_slider := %BGMVolume
@onready var sfx_slider := %SFXVolume
@onready var back_button := $MarginContainer/VBoxContainer/HBoxContainer/BackButton

const MAGIC_VALUE = 25

func _ready():
	back_button.grab_focus()
	# Set sliders to current bus volumes
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("BGM")))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

	# Connect signals
	bgm_slider.value_changed.connect(_on_bgm_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)

func _on_bgm_volume_changed(value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), db)

func _on_sfx_volume_changed(value: float):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
				back_button.emit_signal("pressed")
