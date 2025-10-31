extends Node2D

const SPEED = 30
@onready var ray_cast_left: RayCast2D = $rayCastLeft
@onready var ray_cast_right: RayCast2D = $rayCastRight
@onready var ray_cast_down: RayCast2D = $rayCastDown
@onready var ray_cast_down_right: RayCast2D = $rayCastDownRight
@onready var ray_cast_down_right_2: RayCast2D = $rayCastDownRight2
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if (not ray_cast_down_right.is_colliding()) and direction == 1:
		direction = -1
		animated_sprite.flip_h = true
	elif (not ray_cast_down_right_2.is_colliding()) and direction == -1:
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * delta * SPEED

func destroy() -> void:
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	call_deferred("queue_free")
