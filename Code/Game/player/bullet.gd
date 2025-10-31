class_name Bullet extends RigidBody2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer
var heart_counter: HeartCounter

func _ready():
	gravity_scale = 0.0
	heart_counter = get_tree().get_first_node_in_group("heart_counter") as HeartCounter

func destroy() -> void:
	if $CollisionShape2D: $CollisionShape2D.set_deferred("disabled", true)
	set_physics_process(false)
	call_deferred("queue_free")

func _on_body_entered(body: Node) -> void:
	if body is Player:
		(body as Player).set_hit(true)
		if heart_counter:
			heart_counter.lose_heart(1)
			if body.has_method("set_gravity_multiplier") and heart_counter.get_current_hearts() == 0:
				body.set_gravity_multiplier(3.5)
		destroy()
