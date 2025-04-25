extends Node3D

var current_level = 2
var current_level_scene: Level = null
const levels := ["res://levels/level1.tscn", "res://levels/level_2.tscn", "res://levels/level_3.tscn", "res://levels/level_4.tscn", "res://levels/level_5.tscn"]
@onready var narratives := [
	# Narrative.new("George always hung out with "),
	Narrative.new("George always had the company Sam, but still felt alone. Was it a him problem? Or a them problem? What he did know  was that he could really jump. Surely that had to count for something.", load("res://GeorgeWasAlone.mp3")),
	Narrative.new("Sam knew he wasn't much compared to George. He was grateful for George's friendship, but couldn't shake the feeling that he held George back. Was he selfish for wanting to keep a lifelong friend?", load("res://GeorgeWasAlone.mp3")),
	Narrative.new("Alex was fast, of both body and mind. He made George believe there was really more for him, if only he were willing to make sacrifices. Both Sam and George were acutely aware of what that sacrifice would be.", load("res://GeorgeWasAlone.mp3")),
]

@onready var viewport = $SubViewportContainer/SubViewport
@onready var narrativeText = %LevelNarrative as RichTextLabel
@onready var narrativeAudioPlayer = %NarrativeAudioPlayer as AudioStreamPlayer
@onready var narrativeContainer = %PanelContainer

var original_position: Vector2

func _ready() -> void:
	narrativeAudioPlayer.finished.connect(_on_script_finished)
	original_position = narrativeContainer.position
	load_level(current_level)


func load_level(level_idx: int):
	# drop current level, load level at levels index
	var level_scene = load(levels[level_idx])
	current_level_scene = level_scene.instantiate()
	viewport.add_child(current_level_scene)
	current_level_scene.level_completed.connect(level_transition)
	narrativeContainer.modulate = Color(1, 1, 1, 0)
	narrativeText.text = narratives[level_idx].text
	narrativeAudioPlayer.stream = narratives[level_idx].audio
	narrativeAudioPlayer.play()
	var tween = create_tween()
	tween.tween_property(narrativeContainer, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.parallel().tween_property(narrativeContainer, "position", narrativeContainer.position + Vector2(0, 20), 1)

func level_transition():
	await current_level_scene.wrap_up()
	current_level_scene.queue_free()
	current_level = current_level + 1
	load_level(current_level)


func _on_script_finished():
	# Fades out the narrative text using a tween
	var tween = create_tween()
	tween.tween_property(narrativeContainer, "modulate", Color(1, 1, 1, 0), 1)
	tween.finished.connect(_on_narrative_finished)

func _on_narrative_finished():
	narrativeContainer.position = original_position
