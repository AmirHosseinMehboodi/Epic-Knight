# DeathScreen.gd
class_name DeathScreen
extends Control

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont: CenterContainer = $ColorRect/CenterContainer
@onready var title_label: Label = center_cont.get_node(^"VBoxContainer/Label")
@onready var try_again_button: Button = center_cont.get_node(^"VBoxContainer/TryAgainButton")
@onready var quit_button: Button = center_cont.get_node(^"VBoxContainer/QuitButton")
@onready var lose_sound := $YouLost as AudioStreamPlayer2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED  # UI still works while paused
	hide()

func open(title := "You Died :(") -> void:
	show()
	$YouLost.play()
	get_tree().paused = true
	title_label.text = title
	try_again_button.grab_focus()

	# start positions for tween (same trick you used)
	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5

	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 1.0, fade_in_duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 1.0, fade_in_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func close() -> void:
	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 0.0, fade_out_duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 0.5, fade_out_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_callback(hide)

func _on_try_again_button_pressed() -> void:
	# Unpause, then reload the current scene (simple “reset game”)
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
