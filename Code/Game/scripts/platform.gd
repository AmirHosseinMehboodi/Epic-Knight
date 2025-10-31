extends AnimatableBody2D

@export var move_distance: float = 100.0
@export var move_speed: float = 50.0

var moving: bool = false
var start_position: Vector2
var direction: int = 1

func _ready() -> void:
	start_position = global_position

func start_moving() -> void:
	moving = true

func stop_moving() -> void:
	moving = false

func _process(delta: float) -> void:
	if not moving:
		return

	# مثال: حرکت به بالا به اندازه move_distance و سپس توقف
	global_position.y -= move_speed * delta * direction
	if abs(global_position.y - start_position.y) >= move_distance:
		moving = false
