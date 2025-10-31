# Coin.gd
extends Area2D

@onready var counter := get_tree().get_first_node_in_group("coin_counter")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		# prevent double triggers if there are multiple shapes
		set_deferred("monitoring", false)

		if counter:
			counter.collect_coin()

		queue_free()
