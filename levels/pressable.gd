extends Node3D

@export var axis: Vector3 = Vector3.UP
@export var press_distance: float = 0.25
@export var mechanism: Mechanism

@onready var mesh = $Mesh
@onready var area = $Area
@onready var grace_area = $GraceArea
@onready var spawn_pos = position

var pressed = false
var grace = false
var current_depth = 0.0
var speed = 1


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	grace_area.body_entered.connect(_on_grace_entered)
	grace_area.body_exited.connect(_on_grace_exited)


func _process(delta):
	if pressed:
		current_depth = clamp(current_depth + (delta * speed), 0.0, press_distance)
		if current_depth < press_distance:
			position += axis * delta * speed
		else:
			mechanism.activate()
	else:
		if grace == false:
			current_depth = clamp(current_depth - (delta * speed), 0.0, press_distance)
			if current_depth > 0.0:
				# Move back to the original position
				position -= axis * delta * speed
			else:
				mechanism.deactivate()


func _on_body_entered(body):
	if body is Player: # Or use groups
		pressed = true

func _on_body_exited(body):
	if body is Player:
		pressed = false

func _on_grace_entered(body):
	if body is Player:
		grace = true

func _on_grace_exited(body):
	if body is Player:
		grace = false
