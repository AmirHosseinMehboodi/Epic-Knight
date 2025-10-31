# EnemyKillZone.gd
extends Area2D

@onready var slime: AudioStreamPlayer2D = $"../../EnemyDamage"

@onready var enemy := get_parent()  # parent is the Enemy node

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
		
	slime.play()
		
	if enemy and enemy.has_method("destroy"):
		enemy.destroy()
		
		# give the player a bounce
		body.velocity.y = -300.0
