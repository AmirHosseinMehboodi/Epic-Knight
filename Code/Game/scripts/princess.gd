extends Area2D

@onready var win_screen: WinScreen = $"../InterfaceLayer/WinScreen"



func _on_body_entered(body: Node2D) -> void:
	win_screen.open()
