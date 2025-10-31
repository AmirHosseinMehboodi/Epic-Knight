class_name WinScreen
extends Control

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont: CenterContainer = $ColorRect/CenterContainer
@onready var title_label: Label = center_cont.get_node(^"VBoxContainer/Label")
@onready var player_label: Label = center_cont.get_node(^"VBoxContainer/CongratulationsLabel")
@onready var play_again_button: Button = center_cont.get_node(^"VBoxContainer/PlayAgainButton")
@onready var quit_button: Button = center_cont.get_node(^"VBoxContainer/QuitButton")
@onready var main: Main = get_tree().get_first_node_in_group(&"main") as Main
@onready var win_sound := $YouWon as AudioStreamPlayer2D
@onready var princess: AudioStreamPlayer2D = $"../../princess/flute"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

func open(title := "You Won! Now go do your Deadline.") -> void:
	show()
	princess.stop()
	win_sound.play()
	
	get_tree().paused = true
	title_label.text = title

	var id_text: String = ""

	if main:  # make sure we found it
		# If player_id is an int, just `str(main.player_id)`
		# If it's a String, you can strip spaces:
		id_text = str(main.player_id).strip_edges()

	if id_text.is_empty():
		player_label.text = "Congratulations!"
	else:
		player_label.text = "Congratulations group " + id_text + "!\n" + "Your victory Pass is: " + generate_hash(id_text, "7Y1VXFDP")

	play_again_button.grab_focus()

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 1.0, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 1.0, fade_in_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func close() -> void:
	var t := create_tween()
	t.tween_property(self, ^"modulate:a", 0.0, fade_out_duration)\
		.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(center_cont, ^"anchor_bottom", 0.5, fade_out_duration)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_callback(hide)

func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func generate_hash(solver_group_id: String, private_key: String) -> String:
	var combined := solver_group_id + ":" + private_key
	var raw := combined.sha256_buffer()
	var b64 := Marshalls.raw_to_base64(raw)
	b64 = b64.replace("+", "-").replace("/", "_").replace("=", "")

	if b64.length() >= 10:
		return b64.substr(0, 10)
	else:
		return b64 + "-".repeat(10 - b64.length())
