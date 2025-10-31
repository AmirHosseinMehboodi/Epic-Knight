# HeartCounter.gd
class_name HeartCounter
extends Panel

signal out_of_hearts

@export var max_hearts := 5
var current_hearts := 5

@onready var _label: Label = $Label

var death_screen: DeathScreen

func _ready() -> void:
	death_screen = get_tree().get_first_node_in_group("death_screen") as DeathScreen
	_update()
	($AnimatedSprite2D as AnimatedSprite2D).play()

func _update() -> void:
	_label.text = str(current_hearts)

func lose_heart(amount: int = 1) -> void:
	current_hearts = max(current_hearts - amount, 0)
	_update()
	# optional: _sprite.play("heart_hit")
	if current_hearts == 0:
		death_screen.open()
		
func get_current_hearts() -> int:
	return current_hearts
