extends Area2D

@export var platform_path: NodePath
#@onready var platform: AnimatableBody2D = $platform
@onready var platform: AnimatableBody2D = get_node_or_null(platform_path)


func _on_body_entered(body):
	var anim_player = platform.get_node("AnimationPlayer")
	anim_player.play("new_animation")
