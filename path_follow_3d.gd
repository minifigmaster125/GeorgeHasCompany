extends PathFollow3D

@export var speed: float = 0.5 # Adjust speed as needed
@export var progress_curve: Curve

var dir = 1
var t = 0


func _ready():
	t = randf()

func _physics_process(delta):
	t += dir * speed * delta
	if progress_ratio >= 0.99:
		progress_ratio = 0.99
		dir = -1
	elif progress_ratio <= 0.01:
		progress_ratio = 0.01
		dir = 1
	progress_ratio = progress_curve.sample(t) # Moves the platform along the path
