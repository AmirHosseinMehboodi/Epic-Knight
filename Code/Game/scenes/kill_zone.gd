# KillZone.gd
extends Area2D

@onready var timer: Timer = $Timer
var heart_counter: HeartCounter

func _ready() -> void:
	heart_counter = get_tree().get_first_node_in_group("heart_counter") as HeartCounter
	if heart_counter:
		heart_counter.out_of_hearts.connect(_on_out_of_hearts)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	# Lose one heart
	if heart_counter:
		heart_counter.lose_heart(1)
		if body.has_method("set_hit"):
			body.set_hit(true)
		if body.has_method("set_gravity_multiplier") and heart_counter.get_current_hearts() == 0:
			body.set_gravity_multiplier(3.5)

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	# (If you changed gravity above, also restore it here if needed.)

func _on_out_of_hearts() -> void:
	Engine.time_scale = 1.0
	var tree := get_tree()
	if tree:
		# Defer so it runs safely after the current frame
		tree.call_deferred("reload_current_scene")
