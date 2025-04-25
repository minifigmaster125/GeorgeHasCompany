extends Area3D

var character_on_top: CharacterBody3D = null

func _on_body_entered(body: Node3D):
	if body is CharacterBody3D:
		character_on_top = body
		var offset = (body.global_position - global_position)
		offset.y = 0 # Prevent upward force
		offset = offset.normalized()
		body.velocity += offset * 4
	
func _physics_process(delta):
	if character_on_top:
		var offset = (character_on_top.global_position - global_position)
		offset.y = 0 # Prevent upward force
		offset = offset.normalized()
		character_on_top.velocity += offset * 2


func _on_body_exited(body):
	character_on_top = null
