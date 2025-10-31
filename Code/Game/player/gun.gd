class_name Gun extends Marker2D
## Represents a weapon that spawns and shoots bullets.
## The Cooldown timer controls the cooldown duration between shots.


const BULLET_VELOCITY = 500.0
const BULLET_SCENE = preload("res://player/bullet.tscn")

@onready var sound_shoot := $Shoot as AudioStreamPlayer2D
@onready var timer := $CoolDown as Timer


func shoot(direction: float = 1.0) -> bool:
	if not timer.is_stopped():
		return false
	var bullet := BULLET_SCENE.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)

	bullet.set_as_top_level(true)
	add_child(bullet)
	sound_shoot.play()
	timer.start()
	return true
