extends CharacterBody3D
class_name Player

@export var jump_force: float = 20.0
@export var gravity: float = 9.8
@export var acceleration: float = 15.0
@export var decceleration: float = 15.0
@export var max_speed: float = 5.0
@export var mass: float = 5.0
@export var turn_speed: float = 3.0
@export var active = false

var jumped = false
var direction: Vector3 = Vector3.ZERO
var attached: Array[Dictionary] = []
var airborne = false
var last_velocity: Vector3 = Vector3.ZERO
var carried = false
var coyote_timer = Timer.new()
var coyote = false

var landingAudioPlayer: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
var jumpingAudioPlayer: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
const landing_sound = preload("res://sfx/landing.ogg")
@export var jump_sound = AudioStream
@export var spawn_location: Node3D

@onready var topArea: Area3D


func _ready():
	landingAudioPlayer.stream = landing_sound
	jumpingAudioPlayer.stream = jump_sound
	jumpingAudioPlayer.volume_db = -20.0
	add_child(landingAudioPlayer)
	add_child(jumpingAudioPlayer)
	set_collision_layer_value(1, true)
	set_collision_layer_value(2, true)
	set_collision_layer_value(3, true)
	set_collision_mask_value(1, true)
	topArea = get_node_or_null("TopArea")
	
	
func _physics_process(delta):
	if active:
		direction.x = 0
		direction.z = 0
		direction.y = 0
		if Input.is_action_pressed("move_forward"):
			direction.z -= 1.0
		if Input.is_action_pressed("move_backward"):
			direction.z += 1.0
		if Input.is_action_pressed("move_left"):
			direction.x -= 1.0
		if Input.is_action_pressed("move_right"):
			direction.x += 1.0
		if (is_on_floor()) and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
			jumpingAudioPlayer.play()


		var d = direction.normalized()
		
		
		if d.x != 0:
			var angle = Vector3.BACK.signed_angle_to(Vector3(d.x, 0, 0), Vector3.UP)
			rotation.y = lerp_angle(rotation.y, rotation.y + angle, delta * turn_speed)
			d.x = 0

		d = (basis * d).normalized()
		
		velocity.x = lerp(velocity.x, d.x * max_speed, delta * (decceleration if d.x == 0 else acceleration))
		velocity.z = lerp(velocity.z, d.z * max_speed, delta * (decceleration if d.z == 0 else acceleration))

	for a in attached:
		if velocity.y > 0 && a.body.test_move(a.body.global_transform, Vector3(0, 1, 0)):
			velocity.y = 0
		else:
			a.body.position = position + a.dist
			a.body.rotation.y = rotation.y

	if is_on_floor():
		if airborne:
			airborne = false
			# play landing sound
			play_landing_sound(abs(last_velocity.y))

	if abs(velocity.y) > 0:
			airborne = true

	if (!carried):
		last_velocity = velocity
		velocity.y -= mass * gravity * delta
		move_and_slide()


func activate():
	carried = false
	set_collision_layer_value(1, true)
	attach_bodies()

	active = true
	velocity = Vector3.ZERO
	$CharacterCamera.current = true

	
func deactivate():
	clear_attached()
	velocity = Vector3.ZERO
	active = false
	$CharacterCamera.current = false

func play_landing_sound(impact_velocity: float) -> void:
	# Avoid zero velocity (just in case)
	impact_velocity = max(impact_velocity, 0.01)

	# Smooth exponential curve for normalized volume [0..1]
	var normalized := 1.0 - exp(-impact_velocity * 0.2)

	# Convert to dB: from -40 dB (quiet) to 0 dB (full volume)
	var volume_db := lerp(-40.0, 0.0, normalized) as float

	# Apply and play the sound
	landingAudioPlayer.volume_db = volume_db
	landingAudioPlayer.play()

func attach_bodies():
	if topArea:
		topArea.get_overlapping_bodies().map(func(body: Node3D) -> void:
			if body != self and body is CharacterBody3D:
				body.carried = true
				var attachee = {
					"body": body,
					"dist": body.position - position
				}
				attached.append(attachee)
				(body as CharacterBody3D).set_collision_layer_value(1, false)
				# (body as CharacterBody3D).set_collision_mask_value(2, true)
				body.attach_bodies()
				# (body as CharacterBody3D).set_collision_layer_value(3, true)
		)
	print(name)
	print("ATTACHED", attached.map(func(a): return a.body.name))

func clear_attached():
	attached.map(func(a: Dictionary) -> void:
		var body = a.body
		body.velocity = Vector3.ZERO
		body.set_collision_layer_value(1, true)
		# body.set_collision_mask_value(2, false)
		body.clear_attached()
	)
	attached.clear()

func _on_coyote_timeout():
	coyote = false
