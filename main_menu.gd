extends Control

func _ready():
	pass

func _on_option_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_option_audio_pressed():
	%AudioSettings.set_visible(true)
	disable_node(%LandingScreen)
	
func disable_node(node: Node):
	node.set_visible(false)
	node.process_mode = Node.PROCESS_MODE_DISABLED
