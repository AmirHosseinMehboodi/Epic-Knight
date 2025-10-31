extends Area2D

@onready var key_2: Area2D = $"../key2"
@onready var key: AudioStreamPlayer2D = $"../key"


func _on_body_entered(body: Node2D) -> void:
		# Find the tilemap anywhere in the scene tree
	var tilemap = get_tree().get_root().get_node("Game/TileMap")
	if tilemap.has_method("erase_cell"):
		var tile_pos = Vector2i(77, -45)
		var tile_pos1 = Vector2i(78, -45)
		var tile_pos2 = Vector2i(79, -45)
		var tile_pos3 = Vector2i(80, -45)
		var tile_pos4 = Vector2i(77, -46)
		var tile_pos5 = Vector2i(78, -46)
		var tile_pos6 = Vector2i(79, -46)
		var tile_pos7 = Vector2i(80, -46)
		tilemap.erase_cell(1, tile_pos)
		tilemap.erase_cell(1, tile_pos1)
		tilemap.erase_cell(1, tile_pos2)
		tilemap.erase_cell(1, tile_pos3)
		tilemap.erase_cell(1, tile_pos4)
		tilemap.erase_cell(1, tile_pos5)
		tilemap.erase_cell(1, tile_pos6)
		tilemap.erase_cell(1, tile_pos7)
		key.play()
		queue_free()
		key_2.queue_free()
