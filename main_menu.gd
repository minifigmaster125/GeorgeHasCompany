extends Control

func _ready():
	pass

func _on_option_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func _on_option_audio_pressed():
	disable_node(%LandingScreen)
	enable_node(%AudioSettings)
	
func disable_node(node: Node):
	node.set_visible(false)
	node.process_mode = Node.PROCESS_MODE_DISABLED

func enable_node(node: Node):
	node.set_visible(true)
	node.process_mode = Node.PROCESS_MODE_INHERIT


func _on_back_button_pressed():
	disable_node(%AudioSettings)
	disable_node(%ControlsScreen)
	enable_node(%LandingScreen)


func _on_option_controls_pressed():
	disable_node(%LandingScreen)
	enable_node(%ControlsScreen)
