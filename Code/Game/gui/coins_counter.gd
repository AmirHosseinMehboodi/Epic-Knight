class_name CoinsCounter extends Panel

@onready var tilemap: TileMap = $"../../TileMap"
var _coins_collected: int = 0
@export var platform_path: NodePath
@onready var _coins_label := $Label as Label
@onready var key_1: Area2D = $"../../key1"
@onready var platform_22: AnimatableBody2D = $"../../platform22"


func _ready() -> void:
	_coins_label.set_text(str(_coins_collected))
	($AnimatedSprite2D as AnimatedSprite2D).play()


func collect_coin() -> void:
	_coins_collected += 1
	_coins_label.set_text(str(_coins_collected))
	if _coins_collected == 5:
		var tile_pos = Vector2i(-71, 0)
		var tile_pos1 = Vector2i(-72, 1)
		var tile_pos2 = Vector2i(-71, 1)
		var tile_pos3 = Vector2i(-72, 0)
		tilemap.erase_cell(1, tile_pos)
		tilemap.erase_cell(1, tile_pos1)
		tilemap.erase_cell(1, tile_pos2)
		tilemap.erase_cell(1, tile_pos3)
		key_1.visible = true
	if _coins_collected == 15:
		var anim_player = platform_22.get_node("AnimationPlayer")
		anim_player.play("new_animation")
