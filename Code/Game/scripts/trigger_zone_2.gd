extends Area2D
@onready var key_1: Area2D = $"../key1"
@onready var key: AudioStreamPlayer2D = $"../key"

func _on_body_entered(body):
	# Find the tilemap anywhere in the scene tree
	var tilemap = get_tree().get_root().get_node("Game/TileMap")
	if tilemap.has_method("erase_cell"):
		var tile_pos = Vector2i(113, -6)
		var tile_pos1 = Vector2i(113, -7)
		tilemap.erase_cell(1, tile_pos)
		tilemap.erase_cell(1, tile_pos1)
		key.play()
		key_1.queue_free()
	# Remove two tiles by coordinates
	#tilemap.set_cell(0, Vector2i(113, -7))
	#tilemap.erase_cell(0, Vector2i(113, -6))
