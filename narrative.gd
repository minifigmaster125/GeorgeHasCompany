extends Node
class_name Narrative

var text: String
var audio: AudioStream

func _init(text: String, audio: AudioStream) -> void:
	self.text = text
	self.audio = audio