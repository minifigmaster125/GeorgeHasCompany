extends Control

@onready var buttons := %MenuContainer/Menu.get_children()
@onready var menu_container := %MenuContainer
@onready var highlight := %Highlight

var up_sfx := preload("res://sfx/upUi.ogg")
var down_sfx := preload("res://sfx/downUi.ogg")

var selected_index := 0
var current_tween: Tween = null
var move_dist = 0.0
const ANIM_DURATION := 0.15

func _ready():
	$AudioStreamPlayer.volume_db = -10
	buttons[selected_index].grab_focus()
	call_deferred("_move_highlight_to", selected_index, 0, true)

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_W:
				_move_selection(-1)
				$AudioStreamPlayer.stream = up_sfx
				$AudioStreamPlayer.play()
			KEY_S:
				_move_selection(1)
				$AudioStreamPlayer.stream = down_sfx
				$AudioStreamPlayer.play()
			KEY_ENTER, KEY_KP_ENTER:
				# _activate_selected()
				pass

func _move_selection(direction: int):
	move_dist = buttons[0].size.y / 2.0
	buttons[selected_index].release_focus()
	if selected_index == 0 && direction == -1:
		selected_index = 0
		buttons[selected_index].grab_focus()
		_move_highlight_to(selected_index, 0, true)
		return
	if selected_index == buttons.size() - 1 && direction == 1:
		selected_index = buttons.size() - 1
		buttons[selected_index].grab_focus()
		_move_highlight_to(selected_index, 0, true)
		return
	selected_index += direction
	buttons[selected_index].grab_focus()
	_move_highlight_to(selected_index, direction)

func _move_highlight_to(index: int, direction: int = 0, instant := false):
	var target_button := buttons[index]
	var target_position = target_button.global_position
	var target_size = target_button.size

	# Cancel previous tween if it's still running
	if current_tween and current_tween.is_running():
		current_tween.kill()
	
	if index == 0:
		highlight.get_node("TopArrow").visible = false
	elif index == buttons.size() - 1:
		highlight.get_node("BottomArrow").visible = false
	else:
		highlight.get_node("TopArrow").visible = true
		highlight.get_node("BottomArrow").visible = true

	if instant:
		highlight.global_position = target_position
		highlight.size = target_size
		return

	# Create a new tween
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Animate highlight movement
	current_tween.tween_property(
		highlight,
		"global_position",
		target_position - Vector2(0, move_dist * direction),
		ANIM_DURATION)
	current_tween.parallel().tween_property(highlight, "size", target_size, ANIM_DURATION)

	# Animate menu nudge (up if moving down, down if moving up)
	var start_position = menu_container.position
	var nudge_offset = Vector2(0, move_dist * direction * -1)
	var nudge_position = start_position + nudge_offset

	current_tween.parallel().tween_property(menu_container, "position", nudge_position, ANIM_DURATION / 2)

func _process(delta):
	%Display/RotateParent.rotate_y(0.3 * delta)


