extends Area2D

@onready var tilemap: TileMap = $"../../TileMap"

func _on_body_entered(body: Node) -> void:
	print("hello")
	#if body.is_in_group("player"):
	#if body.is_in_group("player"):
		## prevent double triggers if there are multiple shapes
		#set_deferred("monitoring", false)
		#var tile_pos = Vector2i(-71, 1)
		#var tile_pos1 = Vector2i(-72, 0)
		#tilemap.erase_cell(1, tile_pos)
		#tilemap.erase_cell(1, tile_pos1)
#
		#queue_free()
