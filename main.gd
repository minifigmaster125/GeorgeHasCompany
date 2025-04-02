extends Node3D

var current_level = 1
var current_level_scene: Level = null
const levels := ["res://levels/level1.tscn", "res://levels/level_2.tscn"]
@onready var narratives := [
	Narrative.new("George and Sam figured things out together. Sam couldn’t jump much, but he was kind. George liked that. But George was more fond of his own jumping prowess.", load("res://GeorgeWasAlone.mp3")),
	Narrative.new("Helping Sam was starting to feel ... slow. George didn't say it out loud, but he was beginning to waonder if maybe he was holding himself back. He wondered, albeit briefly, how Sam felt about that.", load("res://GeorgeWasAlone.mp3")),
	Narrative.new("Sam enjoyed George's company. Sam was simple, but kind. Sometimes he wondered if held George back.", load("res://GeorgeWasAlone.mp3")),
]

@onready var viewport = $SubViewportContainer/SubViewport
@onready var narrativeText = %LevelNarrative as RichTextLabel
@onready var narrativeAudioPlayer = %NarrativeAudioPlayer as AudioStreamPlayer

func _ready() -> void:
	load_level(current_level)


func load_level(level_idx: int):
	# drop current level, load level at levels index
	var level_scene = load(levels[level_idx])
	current_level_scene = level_scene.instantiate()
	viewport.add_child(current_level_scene)
	current_level_scene.level_completed.connect(level_transition)
	narrativeText.text = narratives[level_idx].text
	narrativeAudioPlayer.stream = narratives[level_idx].audio
	narrativeAudioPlayer.play()

func level_transition():
	await current_level_scene.wrap_up()
	current_level_scene.queue_free()
	current_level = current_level + 1
	load_level(current_level)
