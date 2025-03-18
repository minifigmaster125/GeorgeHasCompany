extends CharacterBody3D

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
var attached: Array[CharacterBody3D] = []
var dist: Vector3 = Vector3.ZERO
# handle input every frame.
func _process(delta: float) -> void:
	pass
	
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
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y = jump_force

		var d = direction.normalized()
		
		
		if d.x != 0:
			var angle = Vector3.BACK.signed_angle_to(Vector3(d.x, 0, 0), Vector3.UP)
			rotation.y = lerp_angle(rotation.y, rotation.y + angle, delta * turn_speed)
			d.x = 0

		d = (basis * d).normalized()
		
		velocity.x = lerp(velocity.x, d.x * max_speed, delta * (decceleration if d.x == 0 else acceleration))
		velocity.z = lerp(velocity.z, d.z * max_speed, delta * (decceleration if d.z == 0 else acceleration))

		for body in attached:
			if velocity.y > 0 && body.test_move(body.global_transform, Vector3(0, 1, 0)):
				velocity.y = 0
			else:
				body.position = position + dist
	velocity.y -= mass * gravity * delta
	move_and_slide()


func activate():
	set_collision_layer_value(1, true)
	set_collision_layer_value(2, false)
	if get_node_or_null("TopArea"):
		($TopArea as Area3D).set_collision_mask_value(2, true)
		$TopArea.get_overlapping_bodies().map(func(body: Node3D) -> void:
			if body != self && body is CharacterBody3D:
				attached.append(body)
				dist = body.position - position
				(body as CharacterBody3D).set_collision_layer_value(2, true)
				(body as CharacterBody3D).set_collision_layer_value(1, false)
		)

	active = true
	velocity = Vector3.ZERO
	$CharacterCamera.current = true
	
func deactivate():
	attached.clear()
	velocity = Vector3.ZERO
	active = false
	$CharacterCamera.current = false
	
