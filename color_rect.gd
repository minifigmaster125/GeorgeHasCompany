extends ColorRect

@export var pixel_size: int = 4
@onready var shader_material = material

func _process(delta):
    # Example: Adjust pixel size based on time (or player distance)
    # var pixel_size = lerp(min_pixel_size, max_pixel_size, abs(sin(Time.get_ticks_msec() / 1000.0)))
    shader_material.set_shader_parameter("pixel_size", Vector2(pixel_size, pixel_size))
